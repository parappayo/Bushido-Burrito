
using System.Security.Cryptography;

using Org.BouncyCastle.Asn1.Pkcs;
using Org.BouncyCastle.Asn1.X509;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.Pkcs;
using Org.BouncyCastle.X509;

namespace BushidoBurrito.Crypto
{
	public class RsaKeyPair
	{
		private const int KeyLengthBits = 2048;

		public byte[] PrivateKey;
		public byte[] PublicKey;

		public static AsymmetricCipherKeyPair Generate()
		{
			using (RSACryptoServiceProvider cryptoProvider = new RSACryptoServiceProvider(KeyLengthBits))
			{
				try {
					return DotNetUtilities.GetRsaKeyPair(cryptoProvider.ExportParameters(true));
				} finally {
					cryptoProvider.PersistKeyInCsp = false;
				}
			}
		}

		public void Generate()
		{
			var keyPair = GenerateKeyPair();

			PrivateKeyInfo privateKeyInfo = PrivateKeyInfoFactory.CreatePrivateKeyInfo(keyPair.Private);
			PrivateKey = privateKeyInfo.GetDerEncoded();

			SubjectPublicKeyInfo publicKeyInfo = SubjectPublicKeyInfoFactory.CreateSubjectPublicKeyInfo(keyPair.Public);
			PublicKey = publicKeyInfo.GetDerEncoded();
		}
	}
}
