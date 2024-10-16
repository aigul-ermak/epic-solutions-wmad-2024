using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Order : BaseEntity
    {
        public int OrderId { get; set; }

        //  [Required(ErrorMessage = "Please enter the PO Number.")]
        //  [StringLength(8, MinimumLength = 8, ErrorMessage = "PO number should be exactly 8 characters in length.")]
        [DisplayName("PO Number")]
        public string? PoNumber { get; set; }

        [Required(ErrorMessage = "Please CreationDate the last name.")]
        [DisplayName("Creation Date")]
        public DateTime CreationDate { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Employee is required.")]
        public int EmployeeId { get; set; }

        [Required(ErrorMessage = "Status is required.")]
        public int StatusId { get; set; }

        public bool POClose { get; set; } = false;

        public byte[]? RecordVersion { get; set; }

    }
}
