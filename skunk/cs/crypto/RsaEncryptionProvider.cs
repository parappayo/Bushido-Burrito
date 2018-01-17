
using System;
using System.Collections.Generic;

using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Encodings;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.Security;

namespace BushidoBurrito.Crypto
{
	public class RsaEncryptionProvider
	{
		private Pkcs1Encoding EncryptCipher;
		private Pkcs1Encoding DecryptCipher;

		public void InitEncryption(byte[] publicKey)
		{
			this.EncryptCipher = new Pkcs1Encoding(new RsaEngine());
			this.EncryptCipher.Init(true, PublicKeyFactory.CreateKey(publicKey));
		}

		public void InitDecryption(byte[] privateKey)
		{
			this.DecryptCipher = new Pkcs1Encoding(new RsaEngine());
			this.DecryptCipher.Init(false, PrivateKeyFactory.CreateKey(privateKey));
		}

		public byte[] Encrypt(byte[] data)
		{
			return ProcessCipher(data, this.EncryptCipher);
		}

		public byte[] Decrypt(byte[] data)
		{
			return ProcessCipher(data, this.DecryptCipher);
		}

		public static byte[] ProcessCipher(byte[] data, IAsymmetricBlockCipher cipher)
		{
			if (cipher == null || data == null) { return null; }

			List<byte> result = new List<byte>();
			int blockSize = cipher.GetInputBlockSize();

			for (int offset = 0; offset < data.Length; offset += blockSize) {
				int nextBlockSize = Math.Min(data.Length - offset, blockSize);
				byte[] processedBlock = cipher.ProcessBlock(data, offset, nextBlockSize);
				result.AddRange(processedBlock);
			}

			return result.ToArray();
		}
	}
}
