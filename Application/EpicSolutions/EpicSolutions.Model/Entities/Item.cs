using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Item : BaseEntity
    {
        public int ItemId { get; set; }

        [Required(ErrorMessage = "Item Name is Required.")]
        [StringLength(45, MinimumLength = 3, ErrorMessage = "Item Name should be 45 in length and 3 characters min.")]
        [DisplayName("Name")]
        public string? ItemName { get; set; }

        [Required(ErrorMessage = "Description is Required.")]
        [StringLength(255, MinimumLength = 5, ErrorMessage = "Description should more than 5 characters.")]
        [DisplayName("Description")]
        public string? Description { get; set; }

        [Required(ErrorMessage = "Quantity is Required.")]
        [Range(1, int.MaxValue, ErrorMessage = "Quantity must be more than 0.")]
        [DisplayName("Quantity")]
        public int Quantity { get; set; }

        [Required(ErrorMessage = "Price is Required.")]
        [Range(typeof(decimal), "0.01", "999999999", ErrorMessage = "Price must be greater than 0")]
        [DisplayName("Price")]
        public decimal ItemPrice { get; set; }

        [Required(ErrorMessage = "Item Purchase Location is Required.")]
        [StringLength(255, MinimumLength = 5, ErrorMessage = "Item Purchase Location should more than 5 characters.")]
        [DisplayName("Purchase Location")]
        public string? ItemPurchaseLocation { get; set; }

        [Required(ErrorMessage = "Item Justification is Required.")]
        [StringLength(255, MinimumLength = 4, ErrorMessage = "Item Justification should more than 4 characters.")]
        [DisplayName("Justification")]
        public string? ItemJustification { get; set; }

        [Required(ErrorMessage = "Status is Required.")]
        [DisplayName("Status")]
        public int StatusId { get; set; }

        [Required(ErrorMessage = "Order is Required.")]
        public int OrderId { get; set; }

        public string DenyReason { get; set; } = "";

        public byte[]? ItemRecordVersion { get; set; }

    }
}
