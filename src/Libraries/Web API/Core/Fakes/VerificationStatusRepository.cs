// ReSharper disable All
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web.Http;
using MixERP.Net.Schemas.Core.Data;
using MixERP.Net.EntityParser;
using MixERP.Net.Framework.Extensions;
using PetaPoco;
using CustomField = PetaPoco.CustomField;

namespace MixERP.Net.Api.Core.Fakes
{
    public class VerificationStatusRepository : IVerificationStatusRepository
    {
        public long Count()
        {
            return 1;
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> GetAll()
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public IEnumerable<dynamic> Export()
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public MixERP.Net.Entities.Core.VerificationStatus Get(short verificationStatusId)
        {
            return new MixERP.Net.Entities.Core.VerificationStatus();
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> Get([FromUri] short[] verificationStatusIds)
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> GetPaginatedResult()
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> GetPaginatedResult(long pageNumber)
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public long CountWhere(List<EntityParser.Filter> filters)
        {
            return 1;
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> GetWhere(long pageNumber, List<EntityParser.Filter> filters)
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public long CountFiltered(string filterName)
        {
            return 1;
        }

        public List<EntityParser.Filter> GetFilters(string catalog, string filterName)
        {
            return Enumerable.Repeat(new EntityParser.Filter(), 1).ToList();
        }

        public IEnumerable<MixERP.Net.Entities.Core.VerificationStatus> GetFiltered(long pageNumber, string filterName)
        {
            return Enumerable.Repeat(new MixERP.Net.Entities.Core.VerificationStatus(), 1);
        }

        public IEnumerable<DisplayField> GetDisplayFields()
        {
            return Enumerable.Repeat(new DisplayField(), 1);
        }

        public IEnumerable<PetaPoco.CustomField> GetCustomFields()
        {
            return Enumerable.Repeat(new CustomField(), 1);
        }

        public IEnumerable<PetaPoco.CustomField> GetCustomFields(string resourceId)
        {
            return Enumerable.Repeat(new CustomField(), 1);
        }

        public object AddOrEdit(dynamic verificationStatus, List<EntityParser.CustomField> customFields)
        {
            return true;
        }

        public void Update(dynamic verificationStatus, short verificationStatusId)
        {
            if (verificationStatusId > 0)
            {
                return;
            }

            throw new ArgumentException("verificationStatusId is null.");
        }

        public object Add(dynamic verificationStatus)
        {
            return true;
        }

        public List<object> BulkImport(List<ExpandoObject> verificationStatuses)
        {
            return Enumerable.Repeat(new object(), 1).ToList();
        }

        public void Delete(short verificationStatusId)
        {
            if (verificationStatusId > 0)
            {
                return;
            }

            throw new ArgumentException("verificationStatusId is null.");
        }


    }
}