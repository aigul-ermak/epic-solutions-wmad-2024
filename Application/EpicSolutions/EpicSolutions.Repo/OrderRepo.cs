using DAL;
using EpicSolutions.Model;
using EpicSolutions.Types;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Security.Cryptography;

namespace EpicSolutions.Repo
{
    public class OrderRepo
    {
        #region Fields

        private readonly DataAccess db = new();

        #endregion


        #region Public Methods



        /// <summary>
        /// Fetched order list from DB using supervisor id 
        /// </summary>
        /// <param name="supervisorId"></param>
        /// <returns></returns>
        public List<OrderDTO> GetOrderBySupervisor(int supervisorId)
        {
            DataTable dt = db.Execute("spGetAllOrdersBySupervisor", new List<Parm> { new("@SupervisorId", SqlDbType.Int, supervisorId) });

            return dt.AsEnumerable().Select(row => PopulateOrderDTO(row)).ToList();
        }


        /// <summary>
        /// Fetched order list from DB using employee id 
        /// </summary>
        /// <param name="employeeId"></param>
        /// <returns></returns>
        public List<OrderDTO> GetOrderByEmployee(int employeeId)
        {
            DataTable dt = db.Execute("spGetAllOrdersByEmployee", new List<Parm> { new("@EmployeeId", SqlDbType.Int, employeeId) });

            return dt.AsEnumerable().Select(row => PopulateOrderDTO(row)).ToList();
        }

        /// <summary>
        /// Get all users orders and put them in list
        /// </summary>
        /// <param name="userNumber"></param>
        /// <returns></returns>
        public List<OrderDTO> GetAllOrders(string userNumber)
        {
            DataTable dt = db.Execute("spGetAllOrders", new List<Parm> { new("@EmployeeNumber", SqlDbType.NVarChar, userNumber) });

            return dt.AsEnumerable().Select(row => PopulateOrderDTO(row)).ToList();
        }

        /// <summary>
        /// Get all departments orders and put them to list
        /// </summary>
        /// <param name="department"></param>
        /// <returns></returns>
        public List<OrderDTO> GetAllOrdersByDepartment(string department)
        {
            DataTable dt = db.Execute("spGetAllOrdersByDepartment", new List<Parm> { 
                                                                        new("@Department", SqlDbType.NVarChar, department)                                 
                                                                    });

            return dt.AsEnumerable().Select(row => PopulateOrderDTO(row)).ToList();
        }


        /// <summary>
        /// Get all orders for api
        /// </summary>
        /// <returns></returns>
        public async Task<List<OrderApiDTO>> GetAllOrdersAsync()
        {
            DataTable dt = await db.ExecuteAsync("spGetAllOrdersByStatus");

            return dt.AsEnumerable().Select(row => PopulateApiOrder(row)).ToList();
        }

        /// <summary>
        /// Get all orders for api by user
        /// </summary>
        /// <param name="employeeId"></param>
        /// <returns></returns>
        public async Task<List<OrderSummaryDTO>> GetOrderByUserId(int employeeId)
        {
            DataTable dt = await db.ExecuteAsync("spSearchOrder", new List<Parm> { new("@EmployeeId", SqlDbType.Int, employeeId) });

            return dt.AsEnumerable().Select(row => new OrderSummaryDTO
            {
                OrderId = Convert.ToInt32(row["OrderId"]),
                PoNumber = row["PONumber"].ToString()
            }).ToList();
        }

        /// <summary>
        /// Get all orders for api by supervisor
        /// </summary>
        /// <param name="employeeId"></param>
        /// <returns></returns>
        public async Task<List<OrderSummaryDTO>> GetOrderBySupervisorId(int supervisorId)
        {
            DataTable dt = await db.ExecuteAsync("spGetEmployeeOrdersBySupervisorId", new List<Parm> { new("@SupervisorId", SqlDbType.Int, supervisorId) });

            return dt.AsEnumerable().Select(row => new OrderSummaryDTO
            {
                OrderId = Convert.ToInt32(row["OrderId"]),
                PoNumber = row["PONumber"].ToString()
            }).ToList();
        }


        /// <summary>
        /// Get one order be id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public OrderDTO? GetOrderById(int id)
        {
            DataTable dt = db.Execute("spGetOrderById", new List<Parm> { new("@OrderId", SqlDbType.Int, id) });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return PopulateOrder(row);

        }


        /// <summary>
        /// Get one item by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ItemDTO? GetItemById(int id)
        {
            DataTable dt = db.Execute("spGetItemById", new List<Parm> { new("@ItemId", SqlDbType.Int, id) });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            ItemDTO item = new ItemDTO
            {
                ItemId = Convert.ToInt32(row["ItemId"]),
                ItemName = row["ItemName"].ToString(),
                Description = row["ItemDescription"].ToString(),
                Quantity = Convert.ToInt32(row["ItemQuantity"]),
                ItemPrice = Convert.ToDecimal(row["ItemPrice"]),
                ItemPurchaseLocation = row["ItemPurchaseLocation"].ToString(),
                ItemJustification = row["ItemJustification"].ToString(),
                StatusName = row["ItemStatusName"].ToString(),
                DenyReason = row["DenyReason"].ToString(),
                OrderId = Convert.ToInt32(row["OrderId"]),
                ItemRowVersion = (byte[])row["RecordVersion"]
            };

            item.SubTotal = item.ItemPrice * item.Quantity;
            item.Tax = item.SubTotal * 0.15m;
            item.Total = item.SubTotal + item.Tax;

            return item;
        }

        /// <summary>
        /// Get order with all items belong to it
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public OrderWithItemDTO? GetOrderWithItem(int id)
        {
            DataTable dt = db.Execute("spGetOrderWithItems",
               new List<Parm> { new("@OrderId", SqlDbType.Int, id) });

            if (dt.Rows.Count == 0)
                return null;

            return new OrderWithItemDTO
            {
                OrderDetails = PopulateOrderDTOItem(dt.Rows[0]),
                Items = dt.AsEnumerable()
               .Where(row => row["ItemId"] != DBNull.Value)
               .Select(row => {
                   decimal itemPrice = Convert.ToDecimal(row["ItemPrice"]);
                   int quantity = Convert.ToInt32(row["ItemQuantity"]);
                   decimal subtotal = itemPrice * quantity;
                   decimal tax = subtotal * 0.15m;
                   decimal total = subtotal + tax;

                   return new ItemDTO
                   {
                       ItemId = Convert.ToInt32(row["ItemId"]),
                       ItemName = row["ItemName"].ToString(),
                       Description = row["ItemDescription"].ToString(),
                       Quantity = quantity,
                       ItemPrice = itemPrice,
                       ItemPurchaseLocation = row["ItemPurchaseLocation"].ToString(),
                       ItemJustification = row["ItemJustification"].ToString(),
                       ItemRowVersion = (byte[])row["itemRecordVersion"],
                       SubTotal = subtotal,
                       Tax = tax,
                       Total = total,
                       StatusName = row["ItemStatusName"].ToString(),
                   };
               }).ToList()
            };
        }

        /// <summary>
        /// Get last order number
        /// </summary>
        /// <returns></returns>
        public string? GetLastOrderNumber()
        {
            return db.ExecuteScalar("spGetNewPONumber").ToString();
        }


        /// <summary>
        /// Add Item to db
        /// </summary>
        /// <param name="ord"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public OrderItemDTO AddItemOnly(OrderItemDTO ord)
        {
            List<Parm> parms = new()
            {
                new("@CreationDate", SqlDbType.DateTime2, ord.Order.CreationDate),
                new("@StatusId", SqlDbType.Int, ord.Item.StatusId),
                 new("@OrderId", SqlDbType.Int, ord.Item.OrderId),
                new("@EmployeeId", SqlDbType.Int, ord.Order.EmployeeId),
                new("@ItemName", SqlDbType.NVarChar, ord.Item.ItemName, 45),
                new("@ItemDescription", SqlDbType.NVarChar, ord.Item.Description, 255),
                new("@ItemQuantity", SqlDbType.Int, ord.Item.Quantity),
                new("@ItemPrice", SqlDbType.Decimal, ord.Item.ItemPrice),
                new("@ItemPurchaseLocation", SqlDbType.NVarChar, ord.Item.ItemPurchaseLocation, 255),
                new("@ItemJustification", SqlDbType.NVarChar, ord.Item.ItemJustification, 255),
            };


            if (db.ExecuteNonQuery("spAndItemOnly", parms) > 0)
            {
                ord.Order.OrderId = (int?)parms.FirstOrDefault(o => o.Name == "@OrderId")?.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return ord;
        }

        /// <summary>
        /// Update item
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public Item UpdateItem(Item item)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, item.ItemId),
                new("@ItemName", SqlDbType.NVarChar, item.ItemName, 45),
                new("@ItemDescription", SqlDbType.NVarChar, item.Description, 255),
                new("@ItemQuantity", SqlDbType.Int, item.Quantity),
                new("@ItemPrice", SqlDbType.Decimal, item.ItemPrice),
                new("@ItemPurchaseLocation", SqlDbType.NVarChar, item.ItemPurchaseLocation, 255),
                new("@ItemJustification", SqlDbType.NVarChar, item.ItemJustification, 255),
                new("@StatusId", SqlDbType.Int, item.StatusId),
                new("@ItemRecordVersion", SqlDbType.Timestamp, item.ItemRecordVersion)


            };


            int result = db.ExecuteNonQuery("spUpdateItem", parms);

            if (result == 0) throw new DataException("There was an issue adding the record to the database.");

            return item;
        }

        /// <summary>
        /// Search for duplicate
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public int CheckDuplicate(Item item)
        {
            List<Parm> parms = new()
            {

                new("@ItemName", SqlDbType.NVarChar, item.ItemName, 45),
                new("@ItemDescription", SqlDbType.NVarChar, item.Description, 255),

                new("@ItemPrice", SqlDbType.Decimal, item.ItemPrice),
                new("@ItemPurchaseLocation", SqlDbType.NVarChar, item.ItemPurchaseLocation, 255),
                new("@ItemJustification", SqlDbType.NVarChar, item.ItemJustification, 255),

                new("@OrderId", SqlDbType.Int, item.OrderId)
            };


            int itemId = Convert.ToInt32(db.ExecuteScalar("spCheckOrderDublicate", parms));

            return itemId;
        }

        /// <summary>
        /// Add first item to order(create new order)
        /// </summary>
        /// <param name="ord"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public OrderItemDTO AddOrderItem(OrderItemDTO ord)
        {
            List<Parm> parms = new()
            {
                new("@CreationDate", SqlDbType.DateTime2, ord.Order.CreationDate),
                new("@StatusId", SqlDbType.Int, ord.Order.StatusId),
                new("@EmployeeId", SqlDbType.Int, ord.Order.EmployeeId),
                new("@ItemName", SqlDbType.NVarChar, ord.Item.ItemName, 45),
                new("@ItemDescription", SqlDbType.NVarChar, ord.Item.Description, 255),
                new("@ItemQuantity", SqlDbType.Int, ord.Item.Quantity),
                new("@ItemPrice", SqlDbType.Decimal, ord.Item.ItemPrice),
                new("@ItemPurchaseLocation", SqlDbType.NVarChar, ord.Item.ItemPurchaseLocation, 255),
                new("@ItemJustification", SqlDbType.NVarChar, ord.Item.ItemJustification, 255),
                new("@OrderNum", SqlDbType.Int, 0, direction: ParameterDirection.Output)
            };


            if (db.ExecuteNonQuery("spAddOrderAndItems", parms) > 0)
            {
                ord.Order.OrderId = (int?)parms.FirstOrDefault(o => o.Name == "@OrderId")?.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return ord;
        }


        /// <summary>
        /// Merge duplicated rows
        /// </summary>
        /// <param name="ord"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public OrderItemDTO MergeDuplicate(OrderItemDTO ord)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, ord.Item.ItemId),
                new("@ItemQuantity", SqlDbType.Int, ord.Item.Quantity)
            };

            if (db.ExecuteNonQuery("spMergeDublicate", parms) > 0)
            {
                ord.Order.OrderId = (int?)parms.FirstOrDefault(o => o.Name == "@OrderId")?.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return ord;
        }


        /// <summary>
        /// Delete item(needs to merge method)
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public int ItemDelete(int id)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, id),
            };

            int result = db.ExecuteNonQuery("stItemDelete", parms);

            if (result == 0) throw new DataException("There was an issue adding the record to the database.");
            
            return id;
        }

        /// <summary>
        /// Set status Deny for Item
        /// </summary>
        /// <param name="id"></param>
        /// <param name="status"></param>
        /// <param name="reason"></param>
        /// <param name="rowVersion"></param>
        /// <returns></returns>
        public int SetItemStatusDeny(int id, int status, string reason, byte[] rowVersion)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, id),
                new("@StatusId", SqlDbType.Int, status),
                new("@DenyReason", SqlDbType.NVarChar, reason),
                new("@ItemRecordVersion", SqlDbType.Timestamp, rowVersion),
            };

            return db.ExecuteNonQuery("spUpdateItemStatus", parms);
        }

        /// <summary>
        /// Set status Approve for Item
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public int SetItemStatusApprove(ItemDTO item)
        {

            List<Parm> parms = new()
                    {
                        new("@ItemId", SqlDbType.Int, item.ItemId),
                        new("@StatusId", SqlDbType.Int, 1),
                        new("@ItemRecordVersion", SqlDbType.Timestamp, item.ItemRowVersion),
                   //     new("@Description", SqlDbType.NVarChar, item.Description),
                        new("@Price", SqlDbType.Money, item.ItemPrice),
                        new("@Quantity", SqlDbType.Int, item.Quantity),
                        new("@Location", SqlDbType.NVarChar, item.ItemPurchaseLocation),
                        new("@EditReason", SqlDbType.NVarChar, item.EditReason)
                    };


            return db.ExecuteNonQuery("spUpdateItemStatusApprove", parms);
        }




        /// <summary>
        /// get order id by item id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int GetOrderIdByItemId(int id)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, id),
            };

            return Convert.ToInt32(db.ExecuteScalar("spOrderIdByItemId", parms));
        }

      
        /// <summary>
        /// Change order status
        /// </summary>
        /// <param name="OrderId"></param>
        /// <param name="statusId"></param>
        /// <returns></returns>
        public int OrderStatusChange(int OrderId, int statusId)
        {
            List<Parm> parms = new()
            {
                new("@OrderId", SqlDbType.Int, OrderId),
                new("@StatusId", SqlDbType.Int, statusId)
            };

            return db.ExecuteNonQuery("spUpdateOrderStatus", parms);
        }



        #endregion


        #region Private Methods

        /// <summary>
        /// Populate OrderDTO entity 
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private OrderDTO PopulateOrderDTO(DataRow row)
        {
            OrderDTO order = new OrderDTO
            {
                OrderId = Convert.ToInt32(row["OrderId"]),
                PoNumber = row["PoNumber"].ToString(),
                CreationDate = Convert.ToDateTime(row["CreationDate"]),
                StatusName = row["StatusName"].ToString(),
                EmployeeName = row["EmployeeName"].ToString(),
                SubTotal = Convert.ToDecimal(row["SubTotal"]),
            };

            order.Tax = order.SubTotal * 0.15m;
            order.Total = order.SubTotal + order.Tax;

            return order;
        }


        /// <summary>
        /// Populate Order entity
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private OrderDTO PopulateOrder(DataRow row)
        {
            return new OrderDTO
            {
                OrderId = Convert.ToInt32(row["OrderId"]),
                PoNumber = row["PoNumber"].ToString(),
                CreationDate = Convert.ToDateTime(row["CreationDate"]),
                StatusName = (row["StatusName"]).ToString(),
                EmployeeName = (row["FullName"]).ToString(),
                Email = (row["Email"]).ToString()
            };
        }


        /// <summary>
        /// Populate OrderDTO entity amd ItemDTO
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private OrderDTO PopulateOrderDTOItem(DataRow row)
        {
            OrderDTO order = PopulateOrderDTO(row);

            order.Department = row["DepartmentName"].ToString();
            order.SupervisorName = row["SupervisorName"].ToString();
            order.OrderRowVersion = (byte[])row["orderRecordVersion"];

            return order;
        }

        /// <summary>
        /// Populate OrderDTO entity for API
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private OrderApiDTO PopulateApiOrder(DataRow row)
        {
            return new OrderApiDTO
            {
                OrderId = Convert.ToInt32(row["OrderId"]),
                OrderNumber = row["PoNumber"].ToString(),
                CreationDate = Convert.ToDateTime(row["CreationDate"]),
                SupervisorName = row["SupervisorName"].ToString(),
                StatusName = row["StatusName"].ToString(),
                DepartmentId = Convert.ToInt32(row["DepartmentId"]),
              //  DepartmentName = row["DepartmentName"].ToString()
            };
        }


        /// <summary>
        /// Populate Item entity
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private Item PopulateItem(DataRow row)
        {
            return new Item
            {
                ItemId = Convert.ToInt32(row["ItemId"]),
                ItemName = row["ItemName"].ToString(),
                Description = row["Description"].ToString(),
                Quantity = Convert.ToInt32(row["ItemQuantity"]),
                ItemPrice = Convert.ToDecimal(row["ItemPrice"]),
                ItemPurchaseLocation = row["ItemPurchaseLocation"].ToString(),
                ItemJustification = row["ItemJustification"].ToString(),
                StatusId = Convert.ToInt32(row["StatusId"]),
                OrderId = Convert.ToInt32(row["OrderId"])
            };
        }

        #endregion



    }
}
