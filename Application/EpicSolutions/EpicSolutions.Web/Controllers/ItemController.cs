using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using EpicSolutions.Service;
using EpicSolutions.Model;
using EpicSolutions.Web.Models;
using System.Diagnostics;
using System.Security.Cryptography;
using MailKit.Search;
using System.Data;
using static EpicSolutions.MailService.EmailSender;
using static NuGet.Packaging.PackagingConstants;
using Org.BouncyCastle.Asn1.X509;

namespace EpicSolutions.Web.Controllers
{

    public class ItemController : Controller
    {
        private readonly OrderService service = new();

        // GET: ItemController
        public ActionResult Index()
        {
            return View();
        }

        // GET: ItemController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: ItemController/Create
    
        public ActionResult Create(int? orderId/*, string rowVersion*/)
        {

            try
            {
                //check login
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return RedirectToAction(nameof(Index));
                }

                if (orderId == null)
                {
                    return new BadRequestResult();
                }

                ItemDTO orderPart = new();

                orderPart.OrderId = (int)orderId;

                return View(orderPart);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }

        // POST: ItemController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ItemDTO item)
        {
            try
            {
   
                Item itemElement = new Item
                {
                    ItemName = item.ItemName,
                    Description = item.Description,
                    ItemPrice = item.ItemPrice,
                    Quantity = item.Quantity,
                    ItemJustification = item.ItemJustification,
                    ItemPurchaseLocation = item.ItemPurchaseLocation,
                    StatusId = 2,
                    OrderId = (int)item.OrderId,
                    DenyReason = ""
                };

                OrderItemDTO order = new OrderItemDTO
                {
                    Item = itemElement
                };

                //check duplicate

                int? duplicate = service.CheckDuplicate(itemElement);

                if (duplicate == null || duplicate == 0)
                {
                    order = service.AddItemOnly(order);
                }
                else
                {
                    order.Item.ItemId = (int)duplicate;
                    order = service.MergeDuplicate(order);
                }

                if (order.Item.Errors.Count == 0) 
                {
                    TempData["Success"] = $"The Item: {order.Item.ItemName} was Added to order.";
                    //service.OrderVersionUpdate(itemElement.OrderId);
                    return RedirectToAction("Edit", "Order", new { id = item.OrderId });
                }

                return View(item);
            }
            catch
            {
                return View();
            }
        }

        // GET: ItemController/Edit/5
        public ActionResult Edit(int? itemId/*, string rowVersion*/)
        {
            try
            {
                //check login
                var userNumber = HttpContext.Session.GetString("UserNumber");

                if (userNumber == null)
                {
                    return RedirectToAction(nameof(Index));
                }

                if (itemId == null)
                {
                    return new BadRequestResult();
                }

                ItemDTO item = service.GetItem((int)itemId);

                if(item == null) return new NotFoundResult();;

                return View(item);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }

        // POST: ItemController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ItemDTO item)
        {
            try
            {

               Item itemElement = new Item
                {
                    ItemId = item.ItemId,
                    ItemName = item.ItemName,
                    Description = item.Description,
                    ItemPrice = item.ItemPrice,
                    Quantity = item.Quantity,
                    ItemJustification = item.ItemJustification,
                    ItemPurchaseLocation = item.ItemPurchaseLocation,
                    StatusId = 2,
                    OrderId = (int)item.OrderId,
                    ItemRecordVersion = item.ItemRowVersion,
                    DenyReason = ""
                };


                //check duplicate

                int? duplicate = service.CheckDuplicate(itemElement);

                if (duplicate == 0 || duplicate == item.ItemId)
                {
                    itemElement = service.UpdateItem(itemElement);
                }
                else
                {
                    OrderItemDTO order = new OrderItemDTO
                    {
                        Item = itemElement
                    };

                    order.Item.ItemId = (int)duplicate;
                    order = service.MergeDuplicate(order);
                    if(service.ItemDelete(item.ItemId) == 0) return new BadRequestResult();
                }

                if (itemElement.Errors.Count == 0)
                {
                    TempData["Success"] = $"The Item: {itemElement.ItemName} was Edited.";
                    return RedirectToAction("Edit", "Order", new { id = item.OrderId });
                }

                return View(item);

            }
            catch(Exception ex)
            {


                TempData["Error"] = ex.Message.ToString();
                return View(item);
            }
        }


        // GET: ItemController/NoNeed/5
        public ActionResult NoNeed(int? itemId/*, string rowVersion*/)
        {

            try
            {
                
                //check login
                var userName = HttpContext.Session.GetString("UserName");
                if (!string.IsNullOrEmpty(userName))
                {
                    if (itemId == null)
                        return new BadRequestResult();



                    ItemDTO? item = service.GetItem((int)itemId);

                    Item itemElement = new Item
                    {
                        ItemId = item.ItemId,
                        ItemName = item.ItemName,
                        Description = "No Longer Required",
                        ItemPrice = 0,
                        Quantity = 0,
                        ItemJustification = item.ItemJustification,
                        ItemPurchaseLocation = item.ItemPurchaseLocation,
                        StatusId = 3,
                        OrderId = (int)item.OrderId,
                        ItemRecordVersion = item.ItemRowVersion,
                        DenyReason = "No Longer Required"
                    };


                    itemElement = service.UpdateItem(itemElement);


                    if (itemElement.Errors.Count == 0)
                    {
                        TempData["Success"] = $"The Item: {itemElement.ItemName} was excluded.";
                        return RedirectToAction("Edit", "Order", new { id = item.OrderId });
                    }
                    else
                    {
                        TempData["Error"] = "An error has occurred.";
                        return RedirectToAction("Edit", "Order", new { id = item.OrderId });
                    }

                }
                else
                {
                    return RedirectToAction("Index", "Order");
                }

            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message.ToString();
                return RedirectToAction("Index", "Order");
            }

        }



        // GET: ItemController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: ItemController/Delete/5
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
    private ActionResult ShowError(Exception ex)
    {
        return View("Error", new ErrorViewModel
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
            Exception = ex
        });
    }

    }
}
