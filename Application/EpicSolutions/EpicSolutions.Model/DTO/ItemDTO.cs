using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class ItemDTO
    {
        public int ItemId { get; set; }

        [DisplayName("Item Name")]
        [Required(ErrorMessage = "Item Name is Required.")]
        [StringLength(45, MinimumLength = 3, ErrorMessage = "Item Name should be 45 in length and 3 characters min.")]
        public string? ItemName { get; set; }

        [Required(ErrorMessage = "Description is Required.")]
        [StringLength(255, MinimumLength = 5, ErrorMessage = "Description should more than 5 characters.")]
        public string? Description { get; set; }

        [Required(ErrorMessage = "Quantity is Required.")]
        [Range(1, int.MaxValue, ErrorMessage = "Quantity must be more than 0.")]
        public int Quantity { get; set; }

        [DisplayName("Item Price")]
        [Required(ErrorMessage = "Price is Required.")]
        [DisplayFormat(DataFormatString = "{0:C}")]
        [Range(1, int.MaxValue, ErrorMessage = "Price must be more than 0.")]
        public decimal ItemPrice { get; set; }

        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal SubTotal { get; set; }
        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal Tax { get; set; }
        [DisplayFormat(DataFormatString = "{0:C}")]
        public decimal Total { get; set; }

        [DisplayName("Purchase Location")]
        [Required(ErrorMessage = "Item Name is Required.")]
        [StringLength(255, MinimumLength = 5, ErrorMessage = "Item Purchase Location should more than 5 characters.")]
        public string? ItemPurchaseLocation { get; set; }

        [DisplayName("Justification")]
        [Required(ErrorMessage = "Item Name is Required.")]
        [StringLength(255, MinimumLength = 4, ErrorMessage = "Item Justification should more than 4 characters.")]
        public string? ItemJustification { get; set; }

        [DisplayName("Status")]
        public string? StatusName { get; set; }

        [DisplayName("Deny Reason")]
        public string? DenyReason { get; set; } = "";

        [DisplayName("Edit Reason")]
        public string? EditReason { get; set; } = "";

        public int? OrderId { get; set; }

        public byte[]? ItemRowVersion { get; set; }

        public string? stringItemRowVersion { get; set; }

        public string? LocationOriginal { get; set; } = "";
        public decimal ItemPriceOriginal { get; set; } = 0;
        public int QuantityOriginal { get; set; } = 0;

    }
}
