using Lab7.Data;
using Lab7.Models;
using Microsoft.AspNetCore.Mvc;

namespace Lab7.Controllers
{
    public class CommentController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CommentController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult GetComments(int wsrefId)
        {
            var comments = _context.WSREFCOMMENT.Where(c => c.Wsref_id == wsrefId).ToList();
            var sessionId = HttpContext.Session.GetString("SessionId");

            if (string.IsNullOrEmpty(sessionId))
            {
                sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }
            ViewData["SessionId"] = sessionId;
            ViewData["WsrefId"] = wsrefId; 

            return PartialView("_CommentsList", comments);
        }

        public IActionResult AddCommentForm(int wsrefId)
        {
            var sessionId = HttpContext.Session.GetString("SessionId");

            if (string.IsNullOrEmpty(sessionId))
            {
                sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }

            var model = new WSREFCOMMENT { Wsref_id = wsrefId, Session_id = sessionId };
            return PartialView("_AddComment", model); 
        }

        [HttpPost]
        public IActionResult AddComment(WSREFCOMMENT comment)
        {
            var sessionId = HttpContext.Session.GetString("SessionId");

            if (string.IsNullOrEmpty(sessionId))
            {
                sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }

            if (ModelState.IsValid)
            {
                comment.Stamp = DateTime.Now;
                comment.Session_id = sessionId;

                _context.WSREFCOMMENT.Add(comment);
                _context.SaveChanges();
            }

            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        public IActionResult DeleteComment(int id)
        {
            var sessionId = HttpContext.Session.GetString("SessionId");

            if (string.IsNullOrEmpty(sessionId))
            {
                sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }

            var comment = _context.WSREFCOMMENT.FirstOrDefault(c => c.Id == id);
            if (comment == null)
            {
                return NotFound();
            }

            if (comment.Session_id == HttpContext.Session.GetString("SessionId") || User.IsInRole("Owner"))
            {
                _context.WSREFCOMMENT.Remove(comment);
                _context.SaveChanges();
            }

            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public IActionResult EditComment(int id)
        {
            var sessionId = HttpContext.Session.GetString("SessionId");

            if (string.IsNullOrEmpty(sessionId))
            {
                sessionId = Guid.NewGuid().ToString();
                HttpContext.Session.SetString("SessionId", sessionId);
            }

            var comment = _context.WSREFCOMMENT.FirstOrDefault(c => c.Id == id);
            if (comment == null)
            {
                return NotFound(); 
            }

            if (comment.Session_id == HttpContext.Session.GetString("SessionId") || User.IsInRole("Owner"))
            {
                return PartialView("_EditComment", comment); 
            }

            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        public IActionResult EditComment(WSREFCOMMENT comment)
        {
            if (ModelState.IsValid)
            {
                var existingComment = _context.WSREFCOMMENT.FirstOrDefault(c => c.Id == comment.Id);
                if (existingComment != null)
                {
                    existingComment.Comtext = comment.Comtext; 
                    _context.SaveChanges();
                }
            }

            return RedirectToAction("Index", "Home");
        }
    }

}
