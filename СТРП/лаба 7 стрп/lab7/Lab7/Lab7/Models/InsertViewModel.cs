using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Lab7.Models
{
    public class InsertViewModel
    {
        [Required(ErrorMessage = "Ссылка обязательна для ввода")]
        [Display(Name = "Ссылка")]
        public string? Url { get; set; }
        [Required(ErrorMessage = "Описание обязательно для ввода")]
        [Display(Name = "Описание")]
        public string? Description { get; set; }

    }
}
