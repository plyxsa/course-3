using Lab7.Data;
using Lab7.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace Lab7.Controllers
{
    public class HomeController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ILogger<HomeController> _logger;
        private readonly ApplicationDbContext _context;

        public HomeController(RoleManager<IdentityRole> roleManager, ILogger<HomeController> logger, SignInManager<IdentityUser> signInManager, UserManager<IdentityUser> userManager, ApplicationDbContext context)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _roleManager = roleManager;
            _logger = logger;
            _context = context;
        }
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public IActionResult LoadLogInPartialView()
        {
            var model = new SignInViewModel();
            return PartialView("_SignIn", model);
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(SignInViewModel model)
        {
            if (ModelState.IsValid)
            {
                var result = await _signInManager.PasswordSignInAsync("admin", model.Password, false, false);
                var sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }
            return RedirectToAction("Index", "Home");
        }
        [HttpPost]
        public async Task<IActionResult> SignOut()
        {
            var sessionId = Guid.NewGuid().ToString();
            HttpContext.Session.SetString("SessionId", sessionId);
            await _signInManager.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
        [HttpGet]
        public async Task<IActionResult> LoadLinkListPartialViewAsync()
        {
            var links = await _context.WSREF.ToListAsync();
            return PartialView("_LinkList", links);
        }
        [HttpPost]
        public IActionResult IncrementPlus(int id)
        {
            var wsref = _context.WSREF.FirstOrDefault(w => w.Id == id);
            if (wsref != null)
            {
                wsref.Plus++;
                _context.SaveChanges();
            }
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        public IActionResult DecrementMinus(int id)
        {
            var wsref = _context.WSREF.FirstOrDefault(w => w.Id == id);
            if (wsref != null)
            {
                wsref.Minus++;
                _context.SaveChanges();
                return RedirectToAction("Index", "Home");
            }
            return RedirectToAction("Index", "Home");
        }
        [HttpPost]
        public async Task<IActionResult> FilterLinks(string filter)
        {
            if (string.IsNullOrWhiteSpace(filter))
            {
                var all = await _context.WSREF.ToListAsync();
                return PartialView("_LinkList", all);
            }

            var keywords = filter.Split(',', StringSplitOptions.RemoveEmptyEntries)
                                 .Select(k => k.Trim().ToLower())
                                 .ToList();

            var allLinks = await _context.WSREF.ToListAsync();

            var filteredLinks = allLinks
                .Where(link =>
                    link.Description.Split(',', StringSplitOptions.RemoveEmptyEntries)
                    .Select(d => d.Trim().ToLower())
                    .Any(descPart => keywords.Contains(descPart)))
                .ToList();

            return PartialView("_LinkList", filteredLinks);
        }

    }
}
