
using System;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Threading;

using UnityEngine;

namespace BushidoBurrito
{

public class TcpReceiver : MonoBehaviour
{
	public Int32 Port = 1337;

#if !ENABLE_WINMD_SUPPORT
	private TcpListener Listener;
	private Thread ListenerThread;
#endif

	public static List<TcpReceiverObserver> Observers = new List<TcpReceiverObserver>();

	private void Start()
	{
#if !ENABLE_WINMD_SUPPORT
		ListenerThread = new Thread(new ThreadStart(StartListener));
		ListenerThread.Start();
#endif
	}

	private void OnDestroy()
	{
#if !ENABLE_WINMD_SUPPORT
		ListenerThread.Abort();
		StopListener();
#endif
	}

	private void StartListener()
	{
#if !ENABLE_WINMD_SUPPORT
		try
		{
			if (Listener != null)
			{
				Listener.Stop();
			}

#pragma warning disable CS0618 // Type or member is obsolete
			Listener = new TcpListener(Port);
#pragma warning restore CS0618 // Type or member is obsolete

			Listener.Start();

			while (true)
			{
				Thread.Sleep(10);
				AcceptClient();
			}
		}
		catch (SocketException e)
		{
			Debug.Log(string.Format("TcpReceiver SocketException: {0}", e));
		}
#endif
	}

	private void StopListener()
	{
#if !ENABLE_WINMD_SUPPORT
		if (Listener != null)
		{
			Listener.Stop();
			Listener = null;
		}
#endif
	}

#if !ENABLE_WINMD_SUPPORT
	private void AcceptClient()
	{
		try
		{
			TcpClient client = Listener.AcceptTcpClient();
			Debug.Log("TcpReceiver: client connected");
			Read(client, 1024);
			client.Close();
			Debug.Log("TcpReceiver: client disconnected");
		}
		catch (SocketException e)
		{
			Debug.Log(string.Format("TcpReceiver SocketException: {0}", e));
		}
	}
#endif

#if !ENABLE_WINMD_SUPPORT
	private static void Read(TcpClient client, int length)
	{
		Byte[] bytes = new Byte[length];
		String data = null;
		NetworkStream stream = client.GetStream();

		int i;
		while ((i = stream.Read(bytes, 0, bytes.Length)) != 0)
		{
			data = System.Text.Encoding.ASCII.GetString(bytes, 0, i);

			foreach (var observer in Observers)
			{
				observer.HandleData(data);
			}
		}
	}
#endif
}

} // namespace BushidoBurrito
