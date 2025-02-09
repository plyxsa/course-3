namespace lab3a_new.Models;
//для передачи и отображения информации об ошибках
public class ErrorViewModel
{
    public string? RequestId { get; set; }

    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
}