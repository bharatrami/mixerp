// ReSharper disable All
using System.Collections.Generic;
using System.Dynamic;
using MixERP.Net.EntityParser;
using MixERP.Net.Framework;
using PetaPoco;

namespace MixERP.Net.Schemas.Core.Data
{
    public interface IAccountRepository
    {
        /// <summary>
        /// Counts the number of Account in IAccountRepository.
        /// </summary>
        /// <returns>Returns the count of IAccountRepository.</returns>
        long Count();

        /// <summary>
        /// Returns all instances of Account. 
        /// </summary>
        /// <returns>Returns a non-live, non-mapped instances of Account.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> GetAll();

        /// <summary>
        /// Returns all instances of Account to export. 
        /// </summary>
        /// <returns>Returns a non-live, non-mapped instances of Account.</returns>
        IEnumerable<dynamic> Export();

        /// <summary>
        /// Returns a single instance of the Account against accountId. 
        /// </summary>
        /// <param name="accountId">The column "account_id" parameter used on where filter.</param>
        /// <returns>Returns a non-live, non-mapped instance of Account.</returns>
        MixERP.Net.Entities.Core.Account Get(long accountId);

        /// <summary>
        /// Returns multiple instances of the Account against accountIds. 
        /// </summary>
        /// <param name="accountIds">Array of column "account_id" parameter used on where filter.</param>
        /// <returns>Returns a non-live, non-mapped collection of Account.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> Get(long[] accountIds);

        /// <summary>
        /// Custom fields are user defined form elements for IAccountRepository.
        /// </summary>
        /// <returns>Returns an enumerable custom field collection for Account.</returns>
        IEnumerable<PetaPoco.CustomField> GetCustomFields(string resourceId);

        /// <summary>
        /// Displayfields provide a minimal name/value context for data binding Account.
        /// </summary>
        /// <returns>Returns an enumerable name and value collection for Account.</returns>
        IEnumerable<DisplayField> GetDisplayFields();

        /// <summary>
        /// Inserts the instance of Account class to IAccountRepository.
        /// </summary>
        /// <param name="account">The instance of Account class to insert or update.</param>
        /// <param name="customFields">The custom field collection.</param>
        object AddOrEdit(dynamic account, List<EntityParser.CustomField> customFields);

        /// <summary>
        /// Inserts the instance of Account class to IAccountRepository.
        /// </summary>
        /// <param name="account">The instance of Account class to insert.</param>
        object Add(dynamic account);

        /// <summary>
        /// Inserts or updates multiple instances of Account class to IAccountRepository.;
        /// </summary>
        /// <param name="accounts">List of Account class to import.</param>
        /// <returns>Returns list of inserted object ids.</returns>
        List<object> BulkImport(List<ExpandoObject> accounts);


        /// <summary>
        /// Updates IAccountRepository with an instance of Account class against the primary key value.
        /// </summary>
        /// <param name="account">The instance of Account class to update.</param>
        /// <param name="accountId">The value of the column "account_id" which will be updated.</param>
        void Update(dynamic account, long accountId);

        /// <summary>
        /// Deletes Account from  IAccountRepository against the primary key value.
        /// </summary>
        /// <param name="accountId">The value of the column "account_id" which will be deleted.</param>
        void Delete(long accountId);

        /// <summary>
        /// Produces a paginated result of 10 Account classes.
        /// </summary>
        /// <returns>Returns the first page of collection of Account class.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> GetPaginatedResult();

        /// <summary>
        /// Produces a paginated result of 10 Account classes.
        /// </summary>
        /// <param name="pageNumber">Enter the page number to produce the paginated result.</param>
        /// <returns>Returns collection of Account class.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> GetPaginatedResult(long pageNumber);

        List<EntityParser.Filter> GetFilters(string catalog, string filterName);

        /// <summary>
        /// Performs a filtered count on IAccountRepository.
        /// </summary>
        /// <param name="filters">The list of filter conditions.</param>
        /// <returns>Returns number of rows of Account class using the filter.</returns>
        long CountWhere(List<EntityParser.Filter> filters);

        /// <summary>
        /// Performs a filtered pagination against IAccountRepository producing result of 10 items.
        /// </summary>
        /// <param name="pageNumber">Enter the page number to produce the paginated result. If you provide a negative number, the result will not be paginated.</param>
        /// <param name="filters">The list of filter conditions.</param>
        /// <returns>Returns collection of Account class.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> GetWhere(long pageNumber, List<EntityParser.Filter> filters);

        /// <summary>
        /// Performs a filtered count on IAccountRepository.
        /// </summary>
        /// <param name="filterName">The named filter.</param>
        /// <returns>Returns number of Account class using the filter.</returns>
        long CountFiltered(string filterName);

        /// <summary>
        /// Gets a filtered result of IAccountRepository producing a paginated result of 10.
        /// </summary>
        /// <param name="pageNumber">Enter the page number to produce the paginated result. If you provide a negative number, the result will not be paginated.</param>
        /// <param name="filterName">The named filter.</param>
        /// <returns>Returns collection of Account class.</returns>
        IEnumerable<MixERP.Net.Entities.Core.Account> GetFiltered(long pageNumber, string filterName);



    }
}