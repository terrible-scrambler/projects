

def is_prime(num: int) -> bool:
    """ Prime check for a single number"""
    if num < 2:
        return False
    if num % 2 == 0:
        return num == 2
    for i in range(3, int(num**0.5) + 1, 2):
        if num % i == 0:
            return False
    return True


def primes_in_range(start: int, end: int) -> list[int]:
    """Find primes in range that are not div by 5 and under 50"""
    primes = []
    for num in range(start, end + 1):
        if num > 50:
            break
        if num % 5 == 0:
            continue
        if is_prime(num):
            primes.append(num)
    return primes


def main() -> None:
    try:
        start = int(input("Enter the starting number: "))
        end = int(input("Enter the ending number: "))
    except ValueError:
        print("Please enter integers.")
        return

    actual_start, actual_end = sorted((start, end))
    
    primes = primes_in_range(actual_start, max(actual_end, 51))
    
    if not primes:
        print("No primes found in the valid range.")
    else:
        print(f"Prime numbers between {actual_start} and {actual_end} avoiding divisors of 5 and under 50 :")
        for prime in primes:
            print(prime)
        print(f"Total primes found: {len(primes)}")


if __name__ == "__main__":
    main()
