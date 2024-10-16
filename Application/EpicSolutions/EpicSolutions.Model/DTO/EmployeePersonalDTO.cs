using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class EmployeePersonalDTO
    {
        public int Id { get; set; }

        public string? EmployeeNumber { get; set; }

        //[Required(ErrorMessage = "First name is required.")]
        //[StringLength(50, MinimumLength = 2, ErrorMessage = "First name must be between 2 and 50 characters long.")]
        [Display(Name = "First Name")]
        public string? FirstName { get; set; }


        [Display(Name = "Middle Initial (optional)")]
        //[StringLength(1, MinimumLength = 1, ErrorMessage = "Initial should be 1 character long.")]
        public string? MiddleInitial { get; set; }

        //[Required(ErrorMessage = "Last name is required.")]
        //[StringLength(50, MinimumLength = 3, ErrorMessage = "Last name must be between 3 and 50 characters long.")]
        [Display(Name = "Last Name")]
        public string? LastName { get; set; }

        //[Required(ErrorMessage = "Password is required.")]
        [Display(Name = "Password")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{6,}$", ErrorMessage = "Password must contain at least 6 characters with at least one uppercase letter, one lowercase letter, one number, and one special character.")]
        //[DataType(DataType.Password)]
        public string? HashedPassword { get; set; }

        public byte[]? PasswordSalt { get; set; }

        [Required(ErrorMessage = "Street Address is required.")]
        [Display(Name = "Street Address")]
        public string? StreetAddress { get; set; }

        [Required(ErrorMessage = "City is required.")]
        [Display(Name = "City")]
        public string? City { get; set; }

        [Required(ErrorMessage = "Postal code is required.")]
        [RegularExpression("^[A-Za-z]\\d[A-Za-z] \\d[A-Za-z]\\d$", ErrorMessage = "Postal code should have format A1A 0A0")]
        [Display(Name = "Postal Code")]
        public string? PostalCode { get; set; }

        public byte[]? RecordVersion { get; set; }
    }
}
