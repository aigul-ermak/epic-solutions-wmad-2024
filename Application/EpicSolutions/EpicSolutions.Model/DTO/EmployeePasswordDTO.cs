using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class EmployeePasswordDTO
    {
        public int Id { get; set; }

        public string? EmployeeNumber { get; set; }          
        

        [Required(ErrorMessage = "Password is required.")]
        [Display(Name = "Password")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{6,}$", ErrorMessage = "Password must contain at least 6 characters with at least one uppercase letter, one lowercase letter, one number, and one special character.")]
        //[DataType(DataType.Password)]
        public string? HashedPassword { get; set; }

        public byte[]? PasswordSalt { get; set; }

        public byte[]? RecordVersion { get; set; }

    }
}
