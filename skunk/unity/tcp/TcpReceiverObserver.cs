
namespace BushidoBurrito
{

public interface TcpReceiverObserver
{
	/// Will be called from worker threads.
	void HandleData(string data);
}

} // namespace BushidoBurrito
