using System.ComponentModel.DataAnnotations;

namespace EpicSolutions.Web.Models
{
    public class LoginVM
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Employee Number is required.")]
        //[RegularExpression("^[0-9]{8}$", ErrorMessage = "Employee number is invalid. It must be exactly 8 digits.")]
        [Display(Name = "Employee Number")]
        public string? EmployeeNumber { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        //[RegularExpression(@"^(?=.*[A-Z])(?=.*\d)(?=.*\W).{6,}$", ErrorMessage = "Password is invalid. It must be at least 6 characters long and include at least one uppercase letter, one number, and one special character.")]
        [Display(Name = "Password")]
        //[DataType(DataType.Password)]
        public string? Password { get; set; }

    }
}
