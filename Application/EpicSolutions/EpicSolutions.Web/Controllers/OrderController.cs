using EpicSolutions.Model;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Diagnostics;
using PagedList;
using System.Xml;
using Microsoft.EntityFrameworkCore;
using EpicSolutions.MailService;
using static EpicSolutions.MailService.EmailSender;
using MailKit.Search;
using System.ComponentModel.DataAnnotations;

namespace EpicSolutions.Web.Controllers
{
    public class OrderController : Controller
    {


        private readonly OrderService service = new();
        private readonly EpicSolutions.MailService.IEmailSender _emailSender;

        public OrderController( EpicSolutions.MailService.IEmailSender emailSender)
        {
        
            _emailSender = emailSender;
        }

        // GET: OrderController
        public ActionResult Index(string? startDate, string? endDate, string? poNumber, int? page)
        {

            const int pageSize = 5;
            int pageNumber = (page ?? 1);

            ViewBag.StartDate = startDate;
            ViewBag.EndDate = endDate;
            ViewBag.PONumber = poNumber;

            try
            {
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return Redirect("home");
                }
                List<OrderDTO>? orders;
                if (String.IsNullOrEmpty(startDate)&& String.IsNullOrEmpty(endDate) && String.IsNullOrEmpty(poNumber)) {

                    orders = service.GetAllOrders(userNumber);
                    if (orders.Count == 0)
                    {
                        TempData["SearchEmpty"] = "You don't have any orders.";  
                    }

                }
                else
                {
                    orders = service.SearchOrder(userNumber, Convert.ToDateTime(startDate), Convert.ToDateTime(endDate), poNumber);
                    if (orders.Count == 0)
                    {
                        TempData["SearchEmpty"] = "There are no orders matching your request.";
                    }
                }
               

                var pagedOrders = orders.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList();
                ViewBag.TotalPages = (int)Math.Ceiling((double)orders.Count / pageSize);
                ViewBag.CurrentPage = pageNumber;

                return View(pagedOrders);

            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }

        }


        // GET: OrderController
        //[HttpGet("Order/Search")]
        public ActionResult Search(string? startDate, string? endDate, string? poNumber, string? status, string fullName, int? page)
        {

            const int pageSize = 5;
            int pageNumber = (page ?? 1);

            var userNumber = HttpContext.Session.GetString("UserNumber");
            var role = HttpContext.Session.GetString("Role");
            bool isSupervisor = (role == "HR Employee" || role == "Regular Supervisor");

            if (userNumber == null || !isSupervisor)
            {
                return RedirectToAction(nameof(Index));
            }

            ViewBag.StartDate = startDate;
            ViewBag.EndDate = endDate;
            ViewBag.PONumber = poNumber;
            ViewBag.Employee = fullName;
            ViewBag.Status = status;

            try
            {
                var department = HttpContext.Session.GetString("Department");

                if (department == null)
                {
                    return Redirect("home");
                }
                List<OrderDTO>? orders;
                if (String.IsNullOrEmpty(startDate) && String.IsNullOrEmpty(endDate) && String.IsNullOrEmpty(poNumber) && String.IsNullOrEmpty(fullName) && (status == "Pending"|| String.IsNullOrEmpty(status)))
                {

                    orders = service.GetAllOrders(department, "Pending");
                    if (orders.Count == 0)
                    {
                        TempData["SearchEmpty"] = "You don't have any orders in your department.";
                    }

                }
                else
                {
                    orders = service.SearchOrder(department, Convert.ToDateTime(startDate), Convert.ToDateTime(endDate), poNumber, fullName, status);
                    if (orders.Count == 0)
                    {
                        TempData["SearchEmpty"] = "There are no orders matching your request.";
                    }
                }


                var pagedOrders = orders.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList();
                ViewBag.TotalPages = (int)Math.Ceiling((double)orders.Count / pageSize);
                ViewBag.CurrentPage = pageNumber;

                return View(pagedOrders);

            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }

        }



        // GET: OrderController/Details/5
        public ActionResult Details(int id)
        {
            try
            {
                //check login
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return RedirectToAction(nameof(Index));
                }

                if (id == null)
                    return new BadRequestResult();

                OrderWithItemDTO? orderWithItem = service.GetOrderWithItem(id);

                if (orderWithItem == null)
                    return new NotFoundResult();

              

                return View(orderWithItem);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }


       


       // GET: OrderController/Approve/5
        public ActionResult Approve(int id, string rowVersion)
        {

            int orderId = 0;

            try
            {
                //check login
                var userRole = HttpContext.Session.GetString("Role");
                if (!string.IsNullOrEmpty(userRole) && (userRole == "HR Employee" || userRole == "Regular Supervisor"))
                {
                    if (id == null)
                        return new BadRequestResult();

                    byte[] originalRowVersion = Convert.FromBase64String(rowVersion);

                    orderId = service.OrderIdByItemId(id);

                    ItemDTO? item = service.GetItem(id);

                    if(item == null)
                    {
                        return Redirect("home");
                    }
                    item.stringItemRowVersion = rowVersion;
                    item.QuantityOriginal = item.Quantity;
                    item.ItemPriceOriginal = item.ItemPrice;
                    item.LocationOriginal = item.ItemPurchaseLocation;

                    return View(item);
                }
                else
                {
                    return RedirectToAction(nameof(Index));
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message.ToString();
                return RedirectToAction("Details", "Order", new { id = orderId });
            }
        }


        // POST: Order/Approve/5
        [HttpPost]
        public ActionResult Approve(ItemDTO item)
        {

            int orderId = 0;
            try
            {

                var userRole = HttpContext.Session.GetString("Role");
                if (!string.IsNullOrEmpty(userRole) && (userRole == "HR Employee" || userRole == "Regular Supervisor"))
                {

                    int id = item.ItemId;
                    string? reason = item.EditReason;

                    if (id == null || id == 0)
                        return new BadRequestResult();
                    

                    if (item.Quantity != item.QuantityOriginal ||
                        item.ItemPrice != item.ItemPriceOriginal ||
                        item.ItemPurchaseLocation != item.LocationOriginal)
                    {
                        if (string.IsNullOrEmpty(item.EditReason))
                        {
                            TempData["Error"] = "Please indicate the reason for Edit Item.";
                            return RedirectToAction("Approve", "Order", new { id = item.ItemId, rowVersion = item.stringItemRowVersion });
                        }
                    }

                    item.ItemRowVersion = Convert.FromBase64String(item.stringItemRowVersion);

                    int requestResult = service.SetItemStatusApprove(item);
                    if (requestResult == 0)
                        return new NotFoundResult();

                    orderId = service.SetOrderStatus(id);

                    return RedirectToAction("Details", "Order", new { id = orderId });
                }
                else
                {
                    return RedirectToAction(nameof(Index));
                }

            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message.ToString();
                return RedirectToAction("Approve", "Order", new { id = item.ItemId, rowVersion = item.stringItemRowVersion });
            }
        }



        // GET: /Order/Deny
        [HttpGet("Order/Deny/{id}")]
        public ActionResult Deny(int id, string rowVersion)
        {

            ItemDTO? item = service.GetItem(id);
           
            if (item == null)
            {
                return Redirect("home");
            }
            item.stringItemRowVersion = rowVersion;
            return View(item);
        }





        // POST: Order/Deny/5
        [HttpPost]
        public ActionResult Deny(ItemDTO item)
        {

            int orderId = 0;
            try
            {

                //check login
                var userRole = HttpContext.Session.GetString("Role");
                if (!string.IsNullOrEmpty(userRole) && (userRole == "HR Employee" || userRole == "Regular Supervisor"))
                {

                    int id = item.ItemId;
                    string? reason = item.DenyReason;

                    if (id == null)
                        return new BadRequestResult();

                    if (String.IsNullOrEmpty(reason))
                    {
                        TempData["Error"] = "Please indicate the reason for deny.";
                        return RedirectToAction("Deny", "Order", new { id = item.ItemId, rowVersion = item.stringItemRowVersion });
                    }

                    item.ItemRowVersion = Convert.FromBase64String(item.stringItemRowVersion);

                    int requestResult = service.SetItemStatus(id, 3, reason, item.ItemRowVersion);
                    if (requestResult == 0)
                        return new NotFoundResult();

                    orderId = service.SetOrderStatus(id);

                    return RedirectToAction("Details", "Order", new { id = orderId });

                }
                else
                {
                    return RedirectToAction(nameof(Index));
                }
                
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message.ToString();
                return RedirectToAction("Deny", "Order", new { id = item.ItemId, rowVersion = item.stringItemRowVersion });
            }
        }


        // GET: OrderController/Close/5
        public ActionResult Close(int? id/*, string rowVersion*/)
        {
            try
            {
                //check login
                var userRole = HttpContext.Session.GetString("Role");
                if (!string.IsNullOrEmpty(userRole) && (userRole == "HR Employee" || userRole == "Regular Supervisor"))
                {
                    if (id == null)
                        return new BadRequestResult();

                    service.SetOrderStatusByOrderId((int)id, 1);

                    OrderDTO order = service.GetOrderById((int)id);

                    var message = new EmailMessage(

                    new string[] { $"{order.Email}" },
                    $"Your order {order.PoNumber} was processed",
                    $"Order {order.PoNumber} created on {order.CreationDate} by {order.EmployeeName}\n\r" +
                    $"has been processed and close."
                    );

                    _emailSender.SendEmail(message);

                    return RedirectToAction("Details", "Order", new { id });
                }
                else
                {
                    return RedirectToAction(nameof(Index));
                }
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }



        // GET: OrderController/Create
        public ActionResult Create()
        {
            try
            {
                //check login
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return RedirectToAction(nameof(Index));
                }
               
                OrderItemDTO orderPart = pulingData();

                return View(orderPart);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }

        // POST: OrderController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([FromBody] OrderItemDTO ord)
        {
            try
            {

                string? same = ord.OrderNumber;
                if (String.IsNullOrEmpty(same))
                {
                    ord = service.AddOrderWithItems(ord);
                    ord.OrderNumber = GetLastOrderNumber();
                    ViewData["OrderNumber"] = ord.OrderNumber;

                }
                else
                {

                    int OrderId = getOrderId(ord.OrderNumber);
                    ViewData["OrderNumber"] = ord.OrderNumber;
                    ord.Item.OrderId = OrderId;
                    ord.Item.StatusId = 2;

                    int? duplicate = service.CheckDuplicate(ord.Item);

                    if (duplicate == null || duplicate == 0)
                    {
                        ord = service.AddItemOnly(ord);
                    }
                    else
                    {
                        ord.Item.ItemId = (int)duplicate;
                        ord = service.MergeDuplicate(ord);
                    }

                }

                if (ord.Errors.Count == 0)
                {

                    return Json(new { success = true, orderNumber = ord.OrderNumber });

                }

                OrderItemDTO orderPart = pulingData();
                return Json(new { success = false, message = "Validation Error" });

            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        // GET: OrderController/Personal/5
        public ActionResult Edit(int? id)
        {
            try
            {
                //check login
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return RedirectToAction(nameof(Index));
                }

                if (id == null)
                    return new BadRequestResult();

                OrderWithItemDTO? orderPart = service.GetOrderWithItem((int)id);

                if (orderPart == null || orderPart.OrderDetails.StatusName == "Close")
                    return new NotFoundResult();

                return View(orderPart);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }

        // POST: OrderController/Personal/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: OrderController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: OrderController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        #region Private Methods
        private OrderItemDTO pulingData()
        {
            ViewData["EmployeeName"] = HttpContext.Session.GetString("UserName");
            ViewData["DepartmentName"] = HttpContext.Session.GetString("Department");
            ViewData["Status"] = "Pending";
            if (String.IsNullOrEmpty(HttpContext.Session.GetString("Supervisor")))
            {
                ViewData["Supervisor"] = "Don't have a supervisor";
            }
            else
            {
                ViewData["Supervisor"] = HttpContext.Session.GetString("Supervisor");
            }


            var orderPart = new OrderItemDTO();

            //Get EmployeeId
            string? idEmp = HttpContext.Session.GetString("UserId");
            int.TryParse(idEmp, out int empId);
            orderPart.Order.EmployeeId = empId;
            orderPart.Order.StatusId = 2;
            orderPart.Item.StatusId = 2;
            orderPart.Order.POClose = false;

            return orderPart;

        }


        private int getOrderId(string? orderNumber)
        {
            return new ListService().GetOrderID(orderNumber);
        }



        //private List<SelectListItem> GetStatus()
        //{
        //    return new ListService().GetStatusList().Select(c =>
        //        new SelectListItem
        //        {
        //            Value = c.StatusId.ToString(),
        //            Text = c.StatusName
        //        }).ToList();
        //}




        //private List<SelectListItem> GetDepartments()
        //{
        //    return new ListService().GetDepartmentListById()
        //        .Select(c => new SelectListItem
        //        {
        //            Value = c.Id.ToString(),
        //            Text = c.Name
        //        }).ToList();
        //}

        //private IEnumerable<SelectListItem> GetEmployeeName()
        //{
        //    return new ListService().GetSupervisorEmployeeList()
        //       .Select(c => new SelectListItem
        //       {
        //           Value = c.Id.ToString(),
        //           Text = c.Name
        //       }).ToList();
        //}


        private ActionResult ShowError(Exception ex)
        {
            return View("Error", new ErrorViewModel
            {
                RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
                Exception = ex
            });
        }

        private string? GetLastOrderNumber()
        {
            return service.GetLastOrderNumber();
        }


    }
}

#endregion
