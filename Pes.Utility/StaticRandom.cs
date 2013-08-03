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
using System;
using System.Security.Cryptography;

namespace Pes.Utility
{
    public class CryptoRandom : RandomNumberGenerator
    {
        private static RandomNumberGenerator r;

        public CryptoRandom()
        {
            r = RandomNumberGenerator.Create();
        }

        public override void GetBytes(byte[] data)
        {
            r.GetBytes(data);
        }

        public static double NextDouble()
        {
            byte[] b = new byte[4];
            r.GetBytes(b);
            return (double)BitConverter.ToUInt32(b, 0) / UInt32.MaxValue;
        }

        public static int Next(int minValue, int maxValue)
        {
            return (int)Math.Round(NextDouble() * (maxValue - minValue - 1)) + minValue;
        }

        public static int Next()
        {
            return Next(0, Int32.MaxValue);
        }

        public static int Next(int maxValue)
        {
            return Next(0, maxValue);
        }

        public override void GetNonZeroBytes(byte[] data)
        {
            throw new NotImplementedException();
        }
    }
}