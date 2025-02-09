using Microsoft.AspNetCore.Mvc;

namespace ASPCMVC06.Controllers
{
    public class TMResearchController : Controller
    {
        [HttpGet]
        public string M01()
        {
            return $"GET:M01";
        }

        [HttpGet]
        public string M02()
        {
            return "GET:M02";
        }

        [HttpGet]
        public string M03()
        {
            return "GET:M03";
        }

        [HttpGet]
        public string MXX()
        {
            return "Get:MXX";
        }

    }
}
