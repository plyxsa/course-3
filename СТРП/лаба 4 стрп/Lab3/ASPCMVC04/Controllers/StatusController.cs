using ASPCMVC04.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace ASPCMVC04.Controllers
{
    public class StatusController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public StatusController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult S200()
        {
            return Ok();
        }
        public IActionResult S300()
        {
            return StatusCode(302);
        }
        public IActionResult S500()
        {
            try
            {
                int x = 0;
                int result = 1 / x;
            }
            catch
            {
                return StatusCode(500);
            }

            return Ok();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
