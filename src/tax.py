import sys
from pprint import pprint
from typing import Any
from requests import Session

s = Session()


def convert(from_: str = "EUR", to: str = "INR", amount: float = 1) -> float:
    URL = f"http://localhost:8080/v1/latest?base={from_}&symbols={to}"
    converted_amount: float = -1
    try:
        resp: Any = s.get(URL).json()
        converted_amount = amount * resp["rates"][to]
    except Exception:
        try:
            print(
                "falling back to api.frankfurter.dev, run frankfurter locally to selfhost",
                file=sys.stderr,
            )
            URL = f"https://api.frankfurter.dev/v1/latest?base={from_}&symbols={to}"
            resp: Any = s.get(URL).json()
            converted_amount = amount * resp["rates"][to]
        except Exception as e:
            raise e
    print(f"{amount} {from_} = {converted_amount} {to}")
    return converted_amount


# https://www.idfcfirst.bank.in/financial-calculators/income-tax-calculator
def final(income: float) -> None:
    # 75_000 is not taxed
    total = income - 75_000
    tax = 0
    for i in range(6):
        # for every 4 lakh till <24
        new_tax = 4_00_000 * i * 5 / 100
        print("4", i + 1, new_tax)
        tax += new_tax

    # above 24L
    new_tax = (total - 24_00_000) * 30 / 100
    tax += new_tax
    print("rest", round(new_tax, 3))

    # 4% edu cess
    cess = tax * 4 / 100
    tax = tax + cess

    # add back un-taxed 75k
    total = total - tax + 75_000

    # TODO some table format
    pprint(
        {
            "cess": round(cess, 3),
            "monthly": round(total / 12, 3),
            "tax": round(tax, 3),
            "total": round(total, 3),
        }
    )


euro_amount = 2604
if len(sys.argv) > 1:
    euro_amount = float(sys.argv[1])

expected: float = convert("EUR", "INR", euro_amount)
expected -= 5000  # some loss when Forex transaction
final(expected * 11)  # 11 months assuming christmas/dec is ineligible
