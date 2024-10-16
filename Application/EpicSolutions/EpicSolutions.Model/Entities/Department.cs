using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Department: BaseEntity
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Department name is required")]
        [StringLength(128, MinimumLength = 3, ErrorMessage = "Department name must be between 3 and 128 characters long.")]
        [Display(Name = "Department Name")]
        public string? Name { get; set; }

        [Required(ErrorMessage = "Department description is required.")]
        [StringLength(512, ErrorMessage = "Department description cannot exceed 512 characters.")]
        [Display(Name = "Department Description")]
        public string? Description { get; set; }

        [Required(ErrorMessage = "Department invocation date is required.")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:d MMMM yyyy}")]
        [Display(Name = "Department Invocation Date")]
        public DateTime InvocationDate { get; set; }

        public byte[]? RecordVersion { get; set; }
    }
}
