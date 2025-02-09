using Microsoft.AspNetCore.Mvc;

namespace UWSR.Controllers
{
    public class AccountController : Controller
    {
        public IActionResult SwitchMode(string mode)
        {
            if (mode == "admin" || mode == "guest")
            {
                HttpContext.Session.SetString("isAdmin", mode == "admin" ? "true" : "false");
            }
            return RedirectToAction("Index", "Home");
        }
    }
}
