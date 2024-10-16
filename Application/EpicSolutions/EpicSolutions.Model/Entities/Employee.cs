
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Employee : BaseEntity
    {
        public int Id { get; set; }

        public string? EmployeeNumber { get; set; }

        [Required(ErrorMessage = "First name is required.")]
        [StringLength(50, MinimumLength = 2, ErrorMessage = "First name must be between 2 and 50 characters long.")]
        [Display(Name = "First Name")]
        public string? FirstName { get; set; }

        [Display(Name = "Middle Initial (optional)")]
        [StringLength(1, MinimumLength = 1, ErrorMessage = "Initial should be 1 character long.")]
        public string? MiddleInitial { get; set; } 

        [Required(ErrorMessage = "Last name is required.")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Last name must be between 3 and 50 characters long.")]
        [Display(Name = "Last Name")]
        public string? LastName { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [Display(Name = "Password")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{6,}$", ErrorMessage = "Password must contain at least 6 characters with at least one uppercase letter, one lowercase letter, one number, and one special character.")]
        [DataType(DataType.Password)]
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

        [DataType(DataType.Date)]
        [Required(ErrorMessage = "Date of birth is required.")]
        [Display(Name = "Date of Birth")]
        public DateTime? DOB { get; set; }

        [Required(ErrorMessage = "Social Insurance Number is required.")]
        [RegularExpression("\\d{3}-\\d{3}-\\d{3}", ErrorMessage = "Social Insurance Number should have format 123-456-789")]
        [Display(Name = "Social Insurance Number")]
        //[DataType(DataType.Password)]
        public string? SIN { get; set; }

        [DataType(DataType.Date)]
        [Required(ErrorMessage = "Seniority date is required.")]
        [DisplayFormat(DataFormatString = "{0:d MMMM yyyy}")]
        [Display(Name = "Seniority Date")]
        public DateTime? SeniorityDate { get; set; }


        [DataType(DataType.Date)]
        [Display(Name = "Retirement Date")]
        public DateTime? RetirementDate { get; set; }


        [DataType(DataType.Date)]
        [Display(Name = "Terminated Date")]
        public DateTime? TerminationDate { get; set; }

        [DataType(DataType.Date)]
        [Display(Name = "Job Start Date")]
        public DateTime? JobStartDate { get; set; }

        //[Required(ErrorMessage = "Office Location is required.")]
        [Display(Name = "Office Location")]
        public string? OfficeLocation { get; set; }

        [Required(ErrorMessage = "Work Phone is required.")]
        [Display(Name = "Work Phone")]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$", ErrorMessage = "Work Phone should have format 123-456-7890")]
        public string? WorkPhone { get; set; }

        [Required(ErrorMessage = "Cell Phone is required.")]
        [Display(Name = "Cell Phone")]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$", ErrorMessage = "Cell Phone should have format 123-456-7890")]
        public string? CellPhone { get; set; }

        [Required(ErrorMessage = "Email is required.")]
        [Display(Name = "Email")]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        [RegularExpression(@"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,6}$", ErrorMessage = "Invalid Email Address. Please use the format: example@example.com")]
        public string? Email { get; set; }

        public bool IsSupervisor { get; set; }

        [Display(Name = "Department")]     
        public int? DepartmentId { get; set; }

        [Display(Name = "Job Assignment")]
        [Required(ErrorMessage = "Job assignement is required.")]
        public int JobAssignmentId { get; set; }

        [Display(Name = "Supervisor")]
        public int? SupervisorEmployeeId  { get; set; }

        [Display(Name = "Role")]
        public int? RoleId { get; set; }

        [Display(Name = "Status")]
        public int StatusId { get; set; } = 1;
        public byte[]? RecordVersion { get; set; }
    }
}
