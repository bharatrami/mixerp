using System;
using System.Web;
using System.Web.Http;
using System.Web.Optimization;
using System.Web.Routing;
using MixERP.Net.Entities.Office;
using MixERP.Net.Entities.Public.Meta;
using MixERP.Net.FrontEnd.Application;
using MixERP.Net.ReportManager;

namespace MixERP.Net.FrontEnd
{
    public class Global : HttpApplication
    {
        private void Application_Error(object sender, EventArgs e)
        {
            ApplicationError.Handle(this.Server.GetLastError());
        }

        private void Application_Start(object sender, EventArgs e)
        {
            LogManager.IntializeLogger();
            WebJobManager.Register();
            UpdateManager.CheckForUpdates(this.Application);
            Routes.RegisterRoutes(RouteTable.Routes);

            GlobalLogin.CreateTable();
            SalesQuotationValidation.CreateTable();
            Repository.DownloadAndInstallReports();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}