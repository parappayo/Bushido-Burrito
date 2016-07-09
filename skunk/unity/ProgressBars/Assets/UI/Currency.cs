
using UnityEngine;
using UnityEngine.UI;

public class Currency : MonoBehaviour
{
    public Text Caption;
    public GameState Game;

    private void Update()
    {
        Caption.text = Game.Currency.ToString();
    }
}
