
using System;
using System.IO;
using System.Net;
using System.Text;

namespace TwitterSample
{
    public class TwitterUserTimeline
    {
        private static string ApiUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json";

        private static WebRequest CreateRequest(string userName, UInt16 postCount, string bearerToken)
        {
            string url = string.Format("{0}?screen_name={1}&count={2}", ApiUrl, userName, postCount);

            WebRequest request = WebRequest.Create(url);
            request.Method = "GET";
            request.Headers["Authorization"] = string.Format("Bearer {0}", bearerToken);
            return request;
        }

        public static string GetPosts(string userName, UInt16 postCount, string bearerToken)
        {
            WebRequest request = CreateRequest(userName, postCount, bearerToken);
            var response = request.GetResponse();

            using (Stream responseStream = response.GetResponseStream())
            {
                byte[] responseBody = new byte[response.ContentLength];
                long bytesRead = responseStream.Read(responseBody, 0, responseBody.Length);

                if (bytesRead != responseBody.Length)
                {
                    return null;
                }

                return Encoding.UTF8.GetString(responseBody);
            }
        }
    }
}
