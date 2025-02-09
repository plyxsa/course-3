using Microsoft.AspNetCore.Mvc;

namespace ASPCMVC03.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
