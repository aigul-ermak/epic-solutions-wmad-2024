using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class OrderDTO : BaseEntity
    {
        public int OrderId { get; set; }

        [Required(ErrorMessage = "Please enter the PO Number.")]
        [DisplayName("PO Number")]
        [StringLength(8, MinimumLength = 8, ErrorMessage = "PO number should be exactly 8 characters in length.")]
        public string? PoNumber { get; set; }

        [Required(ErrorMessage = "Please CreationDate the last name.")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MMM-dd HH:mm}", ApplyFormatInEditMode = true)]
        [DisplayName("Creation Date")]
        public DateTime CreationDate { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Status is required.")]
        [DisplayName("Employee Name")]
        public string? EmployeeName { get; set; }
        [DisplayName("Department")]
        public string? Department { get; set; }

        [DisplayName("Supervisor")]
        public string? SupervisorName { get; set; }

        [DisplayName("Status Name")]
        public string? StatusName { get; set; }
        
        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal SubTotal { get; set; } = 0;
        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal Tax { get; set; } = 0;
        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal Total { get; set; } = 0;
        public string? Email { get; set; } = "";
        public byte[]? OrderRowVersion { get; set; }

    }
}
