using System.ComponentModel.DataAnnotations;

namespace Lab7.Models
{
    public class UpdateViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "URL обязателен")]
        public string? Url { get; set; }

        [Required(ErrorMessage = "Описание обязательно")]
        public string? Description { get; set; }
    }
}
