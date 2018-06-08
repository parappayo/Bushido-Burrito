
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Web;

using Newtonsoft.Json;

// helpful links
// https://developer.twitter.com/en/docs/basics/authentication/overview/application-only
// https://stackoverflow.com/questions/4256136/setting-a-webrequests-body-data

namespace TwitterSample
{
    public class TwitterAuthBearerToken
    {
        private static string ApiUrl = "https://api.twitter.com/oauth2/token";

        private static WebRequest CreateRequest(string consumerKey, string consumerSecret)
        {
            string bearerTokenCredentials = string.Format("{0}:{1}",
                HttpUtility.UrlEncode(consumerKey),
                HttpUtility.UrlEncode(consumerSecret));

            string authorization = Convert.ToBase64String(Encoding.UTF8.GetBytes(bearerTokenCredentials));

            WebRequest request = WebRequest.Create(ApiUrl);
            request.Method = "POST";
            request.Headers["Authorization"] = string.Format("Basic {0}", authorization);
            request.Headers["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8";
            return request;
        }

        private static WebResponse GetResponse(string consumerKey, string consumerSecret)
        {
            WebRequest request = CreateRequest(consumerKey, consumerSecret);
            using (Stream requestStream = request.GetRequestStream())
            {
                byte[] postBody = Encoding.UTF8.GetBytes("grant_type=client_credentials");
                requestStream.Write(postBody, 0, postBody.Length);
            }
            return request.GetResponse();
        }

        private static string ParseResponse(string responseBody)
        {
            var responseDictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(responseBody);

            if (!responseDictionary["token_type"].Equals("bearer"))
            {
                return null;
            }

            return responseDictionary["access_token"];
        }

        public static string GetToken(string consumerKey, string consumerSecret)
        {
            var response = GetResponse(consumerKey, consumerSecret);

            using (Stream responseStream = response.GetResponseStream())
            {
                byte[] responseBody = new byte[response.ContentLength];
                long bytesRead = responseStream.Read(responseBody, 0, responseBody.Length);

                if (bytesRead != responseBody.Length)
                {
                    return null;
                }

                return ParseResponse(Encoding.UTF8.GetString(responseBody));
            }
        }
    }
}
