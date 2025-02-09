using UWSR.Models;

namespace UWSR
{
    public static class Security
    {
        // Проверка на роль администратора
        public static bool CheckIsAdmin(HttpContext context)
        {
            var role = context.Session.GetString("Role");
            return role == "Admin"; // Если роль "Admin", то пользователь администратор
        }

        // Проверка на владельца комментария
        public static bool CheckIsCommentUser(HttpContext context, Comment comment)
        {
            // Проверяем, совпадает ли SessionId текущего пользователя с SessionId комментария
            if (comment.SessionId != context.Session.Id)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        // Проверка на режим (владелец или гость)
        public static bool CheckIsOwner(HttpContext context)
        {
            var mode = context.Session.GetString("Mode");
            return mode == "Owner";
        }

        public static bool CheckIsGuest(HttpContext context)
        {
            var mode = context.Session.GetString("Mode");
            return mode == "Guest";
        }
    }

}
