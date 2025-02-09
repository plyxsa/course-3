using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Lab7.Models
{
    public class SignInViewModel 
    {
        [Required(ErrorMessage = "Пароль обязателен для ввода")]
        [DataType(DataType.Password)]
        [Display(Name = "Пароль")]
        public string? Password { get; set; }
    }
}
