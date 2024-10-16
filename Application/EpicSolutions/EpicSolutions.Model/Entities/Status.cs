using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Status
    {
        public int StatusId { get; set; }

        [Required(ErrorMessage = "Status Name is required.")]
        public string? StatusName { get; set; }
    }
}
