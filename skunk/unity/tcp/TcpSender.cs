
using System;

#if ENABLE_WINMD_SUPPORT
using System.IO;
using Windows.Foundation;
using Windows.Networking;
using Windows.Networking.Sockets;
#else
using System.Net.Sockets;
#endif

using UnityEngine;

namespace BushidoBurrito
{

public class TcpSender : MonoBehaviour
{
	public Int32 Port = 1337;
	public string IPAddressString = "127.0.0.1";

#if ENABLE_WINMD_SUPPORT
	Windows.Networking.Sockets.StreamSocket Socket;
	IAsyncAction SocketConnectionAction;
#else
	private TcpClient Client;
#endif

	public void OpenConnection()
	{
		Debug.Log(string.Format("TcpSender connecting to {0}:{1}", IPAddressString, Port.ToString()));

		try
		{
#if ENABLE_WINMD_SUPPORT
			Socket = new StreamSocket();
			SocketConnectionAction = Socket.ConnectAsync(new HostName(IPAddressString), Port.ToString());
#else
			Client = new TcpClient(IPAddressString, Port);
#endif
		}
		catch (Exception e)
		{
			Debug.Log(string.Format("TcpSender exception: {0}", e));
		}
	}

	public void Write(string dataStr)
	{
		try
		{
#if ENABLE_WINMD_SUPPORT
			if (Socket == null || SocketConnectionAction.Status != AsyncStatus.Completed) { return; }
			Stream streamOut = Socket.OutputStream.AsStreamForWrite();
			StreamWriter writer = new StreamWriter(streamOut);
			writer.WriteLineAsync(dataStr);
			writer.FlushAsync();
#else
			if (Client == null) { return; }
			NetworkStream stream = Client.GetStream();
			Byte[] data = System.Text.Encoding.ASCII.GetBytes(dataStr);
			stream.Write(data, 0, data.Length);
			// TODO: flush stream? close stream?
#endif
		}
		catch (Exception e)
		{
			Debug.Log(string.Format("TcpSender exception: {0}", e));
		}
	}
}

} // namespace BushidoBurrito
