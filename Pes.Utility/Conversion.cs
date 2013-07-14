/********************************************************************************
    Copyright (C) Binod Nepal, Planet Earth Solutions Pvt. Ltd., Kathmandu.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************************/
namespace Pes.Utility
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Drawing;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using System.Security.Cryptography;
    using System.Text.RegularExpressions;
    using System.Web;

    public static class Conversion
    {

        public static string MapPathReverse(string fullServerPath)
        {
            return @"~\" + fullServerPath.Replace(HttpContext.Current.Request.PhysicalApplicationPath, String.Empty);
        }

        public static short TryCastShort(object value)
        {
            if (value != null)
            {
                short retVal = short.MinValue;

                if (short.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return short.MinValue;
        }

        public static long TryCastLong(object value)
        {
            if (value != null)
            {
                long retVal = long.MinValue;

                if (long.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return long.MinValue;
        }

        public static float TryCastSingle(object value)
        {
            if (value != null)
            {
                float retVal = Single.MinValue;
                if (float.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return Single.MinValue;
        }

        public static double TryCastDouble(object value)
        {
            if (value != null)
            {
                double retVal = double.MinValue;

                if (double.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return double.MinValue;
        }

        public static int TryCastInteger(object value)
        {
            if (value != null)
            {
                if (value is bool)
                {
                    if (Convert.ToBoolean(value, CultureInfo.InvariantCulture))
                    {
                        return 1;
                    }
                    else
                    {
                        return int.MinValue;
                    }
                }

                int retVal = int.MinValue;
                if (int.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return int.MinValue;
        }

        public static DateTime TryCastDate(object value)
        {
            if (value == DBNull.Value)
            {
                return DateTime.MinValue;
            }

            return Convert.ToDateTime(value);
        }

        public static decimal TryCastDecimal(object value)
        {
            if (value != null)
            {
                decimal retVal = default(decimal);
                if (decimal.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return decimal.MinValue;
        }

        public static bool TryCastBoolean(object value)
        {
            if (value != null)
            {
                bool retVal = false;

                if (value is string)
                {
                    if ((value as string).ToLower(CultureInfo.InvariantCulture) == "yes")
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }

                if (bool.TryParse(value.ToString(), out retVal))
                {
                    return retVal;
                }
            }

            return false;
        }

        public static string TryCastString(object value)
        {
            if (value != null)
            {
                if (value is bool)
                {
                    if (Convert.ToBoolean(value, CultureInfo.InvariantCulture) == true)
                    {
                        return "1";
                    }
                    else
                    {
                        return "0";
                    }
                }
                else
                {
                    if (value == System.DBNull.Value)
                    {
                        return string.Empty;
                    }
                    else
                    {
                        string retVal = value.ToString();
                        return retVal;
                    }
                }
            }
            else
            {
                return string.Empty;
            }
        }

        public static string HashSha512(string password, string salt)
        {
            if (password == null)
            {
                return null;
            }

            byte[] bytes = Encoding.Unicode.GetBytes(password + salt);
            using (SHA512CryptoServiceProvider hash = new SHA512CryptoServiceProvider())
            {
                byte[] inArray = hash.ComputeHash(bytes);
                return Convert.ToBase64String(inArray);
            }
        }


        public static Uri GetBackEndUrl(System.Web.HttpContext context, string relativePath)
        {
            string lang = string.Empty;
            string administrationDirectoryName = System.Web.Configuration.WebConfigurationManager.AppSettings["AdministrationDirectoryName"];

            if (context != null)
            {
                if (!string.IsNullOrWhiteSpace(administrationDirectoryName))
                {
                    if ((context.Session == null) || (context.Session["lang"] == null || string.IsNullOrWhiteSpace(context.Session["lang"] as string)))
                    {
                        lang = "en-US";
                    }
                    else
                    {
                        lang = context.Session["lang"] as string;
                    }

                    System.Globalization.CultureInfo culture = new System.Globalization.CultureInfo(lang);
                    if (culture.TwoLetterISOLanguageName == "iv")
                    {
                        culture = new System.Globalization.CultureInfo("en-US");
                    }

                    string virtualDirectory = context.Request.ApplicationPath;
                    bool isSecure = context.Request.IsSecureConnection;
                    string domain = context.Request.Url.DnsSafeHost;
                    int port = context.Request.Url.Port;
                    string path = string.Empty;

                    if (virtualDirectory == "/")
                    {
                        path = string.Format(CultureInfo.InvariantCulture, "{0}:{1}/{2}/{3}/{4}/", domain, port.ToString(), administrationDirectoryName, culture.TwoLetterISOLanguageName, relativePath);
                    }
                    else
                    {
                        path = string.Format(CultureInfo.InvariantCulture, "{0}:{1}{2}/{3}/{4}/{5}/", domain, port.ToString(), virtualDirectory, administrationDirectoryName, culture.TwoLetterISOLanguageName, relativePath);
                    }

                    if (isSecure)
                    {
                        path = "https://" + path;
                    }
                    else
                    {
                        path = "http://" + path;
                    }

                    return new Uri(path, UriKind.Absolute);
                }
            }
            return new Uri("", UriKind.Relative);
        }



        public static string GetAlias(string title)
        {
            if (title == null) return "";

            const int maxlen = 80;
            int len = title.Length;
            bool prevdash = false;
            var sb = new StringBuilder(len);
            char c;

            for (int i = 0; i < len; i++)
            {
                c = title[i];
                if ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9'))
                {
                    sb.Append(c);
                    prevdash = false;
                }
                else if (c >= 'A' && c <= 'Z')
                {
                    // tricky way to convert to lowercase
                    sb.Append((char)(c | 32));
                    prevdash = false;
                }
                else if (c == ' ' || c == ',' || c == '.' || c == '/' ||
                    c == '\\' || c == '-' || c == '_' || c == '=')
                {
                    if (!prevdash && sb.Length > 0)
                    {
                        sb.Append('-');
                        prevdash = true;
                    }
                }
                else if ((int)c >= 128)
                {
                    int prevlen = sb.Length;
                    sb.Append(RemapInternationalCharToAscii(c));
                    if (prevlen != sb.Length) prevdash = false;
                }
                if (i == maxlen) break;
            }

            if (prevdash)
                return sb.ToString().Substring(0, sb.Length - 1);
            else
                return sb.ToString();
        }

        public static string RemapInternationalCharToAscii(char c)
        {
            string s = c.ToString().ToLowerInvariant();
            if ("àåáâäãåą".Contains(s))
            {
                return "a";
            }
            else if ("èéêëę".Contains(s))
            {
                return "e";
            }
            else if ("ìíîïı".Contains(s))
            {
                return "i";
            }
            else if ("òóôõöøőð".Contains(s))
            {
                return "o";
            }
            else if ("ùúûüŭů".Contains(s))
            {
                return "u";
            }
            else if ("çćčĉ".Contains(s))
            {
                return "c";
            }
            else if ("żźž".Contains(s))
            {
                return "z";
            }
            else if ("śşšŝ".Contains(s))
            {
                return "s";
            }
            else if ("ñń".Contains(s))
            {
                return "n";
            }
            else if ("ýÿ".Contains(s))
            {
                return "y";
            }
            else if ("ğĝ".Contains(s))
            {
                return "g";
            }
            else if (c == 'ř')
            {
                return "r";
            }
            else if (c == 'ł')
            {
                return "l";
            }
            else if (c == 'đ')
            {
                return "d";
            }
            else if (c == 'ß')
            {
                return "ss";
            }
            else if (c == 'Þ')
            {
                return "th";
            }
            else if (c == 'ĥ')
            {
                return "h";
            }
            else if (c == 'ĵ')
            {
                return "j";
            }
            else
            {
                return "";
            }
        }

        public static string GetSearchAlias(string title)
        {
            int maxLength = int.MaxValue;
            var match = Regex.Match(title.ToLower(), "[\\w]+");
            StringBuilder result = new StringBuilder("");
            bool maxLengthHit = false;
            while (match.Success && !maxLengthHit)
            {
                if (result.Length + match.Value.Length <= maxLength)
                {
                    result.Append(match.Value + "+");
                }
                else
                {
                    maxLengthHit = true;
                    // Handle a situation where there is only one word and it is greater than the max length.
                    if (result.Length == 0) result.Append(match.Value.Substring(0, maxLength));
                }
                match = match.NextMatch();
            }
            // Remove trailing '-'
            if (result[result.Length - 1] == '+') result.Remove(result.Length - 1, 1);
            return result.ToString();
        }

        public static DateTime GetLocalDateTime(string timeZone, DateTime utc)
        {
            TimeZoneInfo zone = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
            return TimeZoneInfo.ConvertTimeFromUtc(utc, zone);
        }

        public static string GetLocalDateTimeString(string timeZone, DateTime utc)
        {
            TimeZoneInfo zone = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
            DateTime time = TimeZoneInfo.ConvertTimeFromUtc(utc, zone);
            return time.ToLongDateString() + " " + time.ToLongTimeString() + " " + zone.DisplayName;
        }

        public static byte[] TryCastByteArray(Bitmap bitmap)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(bitmap, typeof(byte[]));
        }

        public static byte[] TryCastByteArray(Image image)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(image, typeof(byte[]));
        }

        public static System.Data.DataTable ConvertListToDataTable<T>(System.Collections.Generic.IList<T> list)
        {
            System.ComponentModel.PropertyDescriptorCollection props =
                System.ComponentModel.TypeDescriptor.GetProperties(typeof(T));
            System.Data.DataTable table = new System.Data.DataTable();
            for (int i = 0; i < props.Count; i++)
            {
                System.ComponentModel.PropertyDescriptor prop = props[i];
                table.Columns.Add(prop.Name, prop.PropertyType);
            }
            object[] values = new object[props.Count];
            foreach (T item in list)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = props[i].GetValue(item);
                }
                table.Rows.Add(values);
            }
            return table;
        }

        public static byte[] ConvertImageToByteArray(System.Drawing.Image imageToConvert, System.Drawing.Imaging.ImageFormat formatOfImage)
        {
            using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
            {
                imageToConvert.Save(ms, formatOfImage);
                return ms.ToArray();
            }
        }
    }
}
