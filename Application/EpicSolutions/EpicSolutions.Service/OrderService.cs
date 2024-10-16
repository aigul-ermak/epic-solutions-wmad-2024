
using EpicSolutions.Model;
using EpicSolutions.Repo;
using EpicSolutions.Types;
using System.ComponentModel.DataAnnotations;


namespace EpicSolutions.Service
{
    public class OrderService
    {
        #region Fields
        private readonly OrderRepo repo = new();
        #endregion



        #region Public Methods


        /// <summary>
        /// Get List of all orders
        /// </summary>
        /// <returns></returns>
        public List<OrderDTO> GetAllOrders(string userNumber)
        {
            List<OrderDTO> order = repo.GetAllOrders(userNumber);
            return order;
        }

        /// <summary>
        /// Get PO Per period of 12 month maximum by supervisor
        /// </summary>
        /// <param name="supervisorId"></param>
        /// <param name="periodOfMonth"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public List<OrderDTO> GetPOPerPeriod(int supervisorId, int? periodOfMonth = null)
        {
            if (periodOfMonth > 12) throw new Exception("No more than 12 month could be show");
            
            List<OrderDTO> order = repo.GetOrderBySupervisor(supervisorId).Where(ord => ord.StatusName == "Close").ToList();

            if (periodOfMonth == null)
            {
                order = order.Where(ord => ord.CreationDate > DateTime.Now.AddMonths(-12)).ToList();
            }
            else
            {
                order = order.Where(ord => ord.CreationDate > DateTime.Now.AddMonths(-(int)periodOfMonth)).ToList();
            }

            return order;
        }

        /// <summary>
        /// Get PO Per period of 12 month maximum by employee
        /// </summary>
        /// <param name="employeeId"></param>
        /// <param name="periodOfMonth"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public List<OrderDTO> GetPOPerPeriodEmployee(int employeeId, int? periodOfMonth = null)
        {
            
            if(periodOfMonth > 12) throw new Exception("No more than 12 month could be show");
            
            List<OrderDTO> order = repo.GetOrderByEmployee(employeeId).Where(ord => ord.StatusName == "Close").ToList();

            if (periodOfMonth == null)
            {
                order = order.Where(ord => ord.CreationDate > DateTime.Now.AddMonths(-12)).ToList();
            }
            else
            {
                order = order.Where(ord => ord.CreationDate > DateTime.Now.AddMonths(-(int)periodOfMonth)).ToList();
            }

            return order;
        }

        /// <summary>
        /// Calculated Amount of Expenses per month only approve items included
        /// </summary>
        /// <param name="orders"></param>
        /// <returns></returns>
        public Dictionary<string, decimal> CalculateExpenses(List<OrderDTO> orders)
        {

            Dictionary<string, decimal> expensesPerMonth = new Dictionary<string, decimal>();

            List<string> month = new();

            for (int i = 0; i < 12; i++)
            {
                month.Add(DateTime.Now.AddMonths(-i).ToString("MMMM"));
            }

            expensesPerMonth = month.ToDictionary(month => month, month => (decimal)0);


            foreach (var order in orders)
            {
                var monthKey = order.CreationDate.ToString("MMMM");
                if (expensesPerMonth.TryGetValue(monthKey, out var currentTotal))
                {
                    OrderWithItemDTO orderWithItems = GetOrderWithItem(order.OrderId);
                    decimal orderSubTotal = orderWithItems.Items.Where(it => it.StatusName == "Approve").Sum(it => it.SubTotal);
                    expensesPerMonth[monthKey] = currentTotal + orderSubTotal;
                }
            }

            return expensesPerMonth;
        }

        /// <summary>
        /// Get all orders by department id and status
        /// </summary>
        /// <param name="department"></param>
        /// <param name="status"></param>
        /// <returns></returns>

        public List<OrderDTO> GetAllOrders(string? department, string? status)
        {
            List<OrderDTO> orders = repo.GetAllOrdersByDepartment(department);

            orders = orders.Where(ord => ord.StatusName == status).ToList();

            orders = orders.OrderBy(ord => ord.CreationDate).ToList();

            return orders;
        }

        /// <summary>
        /// Get all orders by department id and status for RESTAPI
        /// </summary>
        /// <param name="departmentId"></param>
        /// <returns></returns>
        public async Task<List<OrderApiDTO>>? GetAllOrdersAsync(int? departmentId)
        {

            List<OrderApiDTO> orders = await repo.GetAllOrdersAsync();

            if (departmentId.HasValue)
            {
                orders = orders.Where(ord => ord.DepartmentId == departmentId.Value).ToList();
            }

            orders = orders.OrderBy(ord => ord.CreationDate).ToList();
            return orders;
        }

        /// <summary>
        /// Get list of order by user id
        /// </summary>
        /// <param name="employeeId"></param>
        /// <returns></returns>
        public async Task<List<OrderSummaryDTO>>? GetUserOrdersListAsync(int? employeeId)
        {

            List<OrderSummaryDTO> orders = await repo.GetOrderByUserId((int)employeeId);

            orders = orders.OrderByDescending(ord => ord.OrderId).ToList();

            return orders;
        }

        /// <summary>
        /// Get list of order by supervisor id
        /// </summary>
        /// <param name="employeeId"></param>
        /// <returns></returns>
        public async Task<List<OrderSummaryDTO>>? GetSupervisorOrdersListAsync(int? employeeId)
        {

            List<OrderSummaryDTO> orders = await repo.GetOrderBySupervisorId((int)employeeId);

            orders = orders.OrderByDescending(ord => ord.OrderId).ToList();

            return orders;
        }



        /// <summary>
        /// Get order by id
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public OrderDTO? GetOrderById(int orderId)
        {
            return repo.GetOrderById(orderId);
        }

        /// <summary>
        /// Search order by date and number
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="orderNumber"></param>
        /// <returns></returns>
        public List<OrderDTO>? SearchOrder(string employeeNumber, DateTime? startDate, DateTime? endDate, string orderNumber)
        {
             List<OrderDTO> orders = repo.GetAllOrders(employeeNumber);

           if(orders.Count != 0)
            {

                if (orderNumber != null)
                {
                    orders = orders.Where(ord =>
                    (ord.PoNumber == orderNumber))
                    .ToList();

                    return orders;
                }

                if (startDate != null && startDate != Convert.ToDateTime(null))
                {
                   orders = orders.Where(ord =>
                   (ord.CreationDate >= startDate))
                   .ToList();
                }

                if (endDate != null && endDate != Convert.ToDateTime(null))
                {
                    orders = orders.Where(ord =>
                    (ord.CreationDate <= endDate))
                    .ToList();
                }
            }


            orders = orders.OrderBy(ord => ord.CreationDate).ToList();

            return orders;

        }


        public List<OrderDTO>? SearchOrder(string department, DateTime? startDate, DateTime? endDate, string? orderNumber, string? employeeName, string? status)
        {
            List<OrderDTO> orders = repo.GetAllOrdersByDepartment(department);

            if (orders.Count != 0)
            {

                if (orderNumber != null)
                {
                    orders = orders.Where(ord =>
                    (ord.PoNumber == orderNumber))
                    .ToList();

                    return orders;
                }

                if (employeeName != null)
                {
                    orders = orders.Where(ord =>
                        ord.EmployeeName.Contains(employeeName))
                    .ToList();
                }

                if (status != null && status != "All")
                {
                    orders = orders.Where(ord =>
                    (ord.StatusName == status))
                    .ToList();

                }

                if (startDate != null && startDate != Convert.ToDateTime(null))
                {
                    orders = orders.Where(ord =>
                    (ord.CreationDate >= startDate))
                    .ToList();
                }

                if (endDate != null && endDate != Convert.ToDateTime(null))
                {
                    orders = orders.Where(ord =>
                    (ord.CreationDate <= endDate))
                    .ToList();
                }
            }


            orders = orders.OrderBy(ord => ord.CreationDate).ToList();

            return orders;

        }

        /// <summary>
        /// Add new items to the order
        /// </summary>
        /// <param name="Ord"></param>
        /// <returns></returns>
        public OrderItemDTO AddItemOnly(OrderItemDTO ord)
        {
            if (MainValidation(ord)) return repo.AddItemOnly(ord);

            return ord;
        }

        /// <summary>
        /// Update Item data
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public Item UpdateItem(Item item)
        {

            if (item.ItemPrice == 0 && item.Quantity == 0 && item.DenyReason == "No Longer Required")
            {
                return repo.UpdateItem(item);
            }
            else
            {
                if (MainValidation(item)) return repo.UpdateItem(item);

                return item;
            }
            
        }



        /// <summary>
        /// Add order with One Item
        /// </summary>
        /// <param name="ord"></param>
        /// <returns></returns>
        public OrderItemDTO AddOrderWithItems(OrderItemDTO ord)
        {
            if (MainValidation(ord)) return repo.AddOrderItem(ord);

            return ord;
        }

        /// <summary>
        /// Get All items of one order
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        //public List<Item> GetItemsByOrderNumber(int orderId)
        //{
        //    return repo.GetItemsByOrderId(orderId);
        //}

        public OrderWithItemDTO? GetOrderWithItem(int id)
        {
            return repo.GetOrderWithItem(id);
        }

        /// <summary>
        /// Get lat order number
        /// </summary>
        /// <returns></returns>
        public string? GetLastOrderNumber()
        {
            string? poNum = repo.GetLastOrderNumber();

            if (String.IsNullOrEmpty(poNum))
            {
                return "00000101";
            }

            return poNum;
        }


        /// <summary>
        /// Check duplicated records in order
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public int CheckDuplicate(Item item)
        {

            int itemId = repo.CheckDuplicate(item);


            return itemId;
        }

        /// <summary>
        /// Merge duplicated records in order
        /// </summary>
        /// <param name="ord"></param>
        /// <returns></returns>
        public OrderItemDTO MergeDuplicate(OrderItemDTO ord)
        {

            if (MainValidation(ord)) return repo.MergeDuplicate(ord);

            return ord;
        }

        /// <summary>
        /// Delete item by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int ItemDelete(int id)
        {
           return repo.ItemDelete(id);
        }


        /// <summary>
        /// Set new status for item
        /// </summary>
        /// <param name="id"></param>
        /// <param name="status"></param>
        /// <param name="reason"></param>
        /// <param name="rowVersion"></param>
        /// <returns></returns>
        public int SetItemStatus(int id, int status, string reason, byte[] rowVersion)
        {
                return repo.SetItemStatusDeny(id, status, reason, rowVersion);
        }

        /// <summary>
        /// Set status approve for item
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public int SetItemStatusApprove(ItemDTO item)
        {
            return repo.SetItemStatusApprove(item);
        }


        /// <summary>
        /// Return order id by item id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int OrderIdByItemId(int id)
        {
            return repo.GetOrderIdByItemId(id);
        }

        /// <summary>
        /// Set order status
        /// </summary>
        /// <param name="orderId"></param>
        /// <param name="statusId"></param>
        /// <returns></returns>
        public int SetOrderStatusByOrderId(int orderId, int statusId)
        {

            int requestResalt = repo.OrderStatusChange(orderId, statusId);
            
            return orderId;
        }

        /// <summary>
        /// Get Item by Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ItemDTO? GetItem(int id)
        {
            return repo.GetItemById(id);
        }

        /// <summary>
        /// SEt order status
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int SetOrderStatus(int id)
        {
            int orderId = repo.GetOrderIdByItemId(id);
            
            OrderWithItemDTO? order = repo.GetOrderWithItem(orderId);

            int orderItemsCount = order.Items.Count;
            int orderPendingItems = order.Items.Where(itm => itm.StatusName == "Pending").Count();
            int orderDenyItems = order.Items.Where(itm => itm.StatusName == "Deny").Count();
            int orderApproveItems = order.Items.Where(itm => itm.StatusName == "Approve").Count();

            int requestResalt = 0;
            if (orderItemsCount != orderPendingItems && order.OrderDetails.StatusName == "Pending")
            {
                requestResalt = repo.OrderStatusChange(orderId, 3);
            }



            return orderId;
        }



        #endregion



        #region Private Methods

        /// <summary>
        /// Calculated total by order
        /// </summary>
        /// <param name="items"></param>
        /// <returns></returns>
        //private decimal CalculateOrderTotal(List<Item> items)
        //{
        //    decimal subTotal = 0;
        //    decimal TAX_RATE = 0.15m;
            
        //    foreach (var item in items)
        //    {
        //        subTotal += item.Quantity * item.ItemPrice;
        //    }

        //    return subTotal + subTotal * TAX_RATE;   
        //}


        /// <summary>
        /// Merge Same Item if it exist in one order
        /// </summary>
        /// <param name="item"></param>
        /// <param name="items"></param>
        /// <returns></returns>
        //private Item MergeSameItem(Item item, List<Item> items)
        //{
        //    foreach (var itm in items)
        //    {
        //        if (itm.ItemName==item.ItemName && itm.Description == item.Description &&
        //            itm.ItemPurchaseLocation == item.ItemPurchaseLocation && item.ItemJustification==item.ItemJustification)
        //        {
        //            int quantity = item.Quantity + itm.Quantity;

        //            Item updateItem = new Item
        //            {
        //                ItemId = itm.ItemId,
        //                ItemName = itm.ItemName,
        //                Description = itm.Description,
        //                Quantity = quantity,
        //                ItemPrice = itm.ItemPrice,
        //                ItemPurchaseLocation = itm.ItemPurchaseLocation,
        //                ItemJustification = itm.ItemJustification,
        //                StatusId = item.StatusId,
        //                OrderId = itm.OrderId
        //            };

        //            if (ValidateItem(item)) return repo.UpdateItem(updateItem);

        //            return updateItem;
        //        }
        //    }
        //    return item;
        //}



        /// <summary>
        /// Item Validation
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        //private bool ValidateItem(Item item)
        //{
        //    // Validate Item
        //    List<ValidationResult> results = new();
        //    Validator.TryValidateObject(item, new ValidationContext(item), results, true);

        //    foreach (ValidationResult e in results)
        //    {
        //        item.AddError(new(e.ErrorMessage, ErrorType.Model));
        //    }

        //    return item.Errors.Count == 0;
        //}

        /// <summary>
        /// Order Validation
        /// </summary>
        /// <param name="order"></param>
        /// <returns></returns>
        //private bool ValidateOrder(Order order)
        //{
        //    // Validate Order
        //    List<ValidationResult> results = new();
        //    Validator.TryValidateObject(order, new ValidationContext(order), results, true);

        //    foreach (ValidationResult e in results)
        //    {
        //        order.AddError(new(e.ErrorMessage, ErrorType.Model));
        //    }
           
        //    return order.Errors.Count == 0;
        //}

        private bool MainValidation(BaseEntity obj)
        {
            // Validate Order
            List<ValidationResult> results = new();
            Validator.TryValidateObject(obj, new ValidationContext(obj), results, true);

            foreach (ValidationResult e in results)
            {
                obj.AddError(new(e.ErrorMessage, ErrorType.Model));
            }

            return obj.Errors.Count == 0;
        }

        #endregion
    }
}
