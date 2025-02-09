using Lab7.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Lab7.Data;

namespace Lab7.Controllers
{
    public class AdminController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ILogger<AdminController> _logger;
        private readonly ApplicationDbContext _context;

        public AdminController(RoleManager<IdentityRole> roleManager, ILogger<AdminController> logger, SignInManager<IdentityUser> signInManager, UserManager<IdentityUser> userManager, ApplicationDbContext context)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _roleManager = roleManager;
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public IActionResult LoadInsertPartialView()
        {
            var model = new InsertViewModel();
            return PartialView("_Insert", model);
        }
        [HttpPost]
        public async Task<IActionResult> Insert(InsertViewModel model)
        {
            if (ModelState.IsValid)
            {
                WSREF wSREF = new WSREF() { Url = model.Url, Description = model.Description, Plus = 0, Minus = 0 };
                _context.WSREF.Add(wSREF);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction("Index", "Home");
        }
        [HttpGet]
        public IActionResult LoadUpdatePartialView(int id)
        {
            var record = _context.WSREF.FirstOrDefault(r => r.Id == id);
            if (record == null)
            {
                return NotFound();
            }

            var model = new UpdateViewModel
            {
                Id = record.Id,
                Url = record.Url,
                Description = record.Description
            };

            return PartialView("_Update", model);
        }
        [HttpPost]
        public async Task<IActionResult> Update(UpdateViewModel model)
        {
            if (ModelState.IsValid)
            {
                var record = _context.WSREF.FirstOrDefault(r => r.Id == model.Id);
                if (record == null)
                {
                    return NotFound();
                }

                record.Url = model.Url;
                record.Description = model.Description;

                await _context.SaveChangesAsync();

            }
            return RedirectToAction("Index", "Home");
        }
        [HttpPost]
        public IActionResult Delete(int id)
        {
            var record = _context.WSREF.FirstOrDefault(x => x.Id == id);
            if (record == null)
            {
                return Json(new { success = false, message = "Запись не найдена" });
            }

            try
            {
                _context.WSREF.Remove(record);
                _context.SaveChanges();
                return Json(new { success = true, redirectUrl = Url.Action("Index", "Home") });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Ошибка при удалении: " + ex.Message });
            }
        }
    }
}