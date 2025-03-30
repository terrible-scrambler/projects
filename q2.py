

class Library:
    def __init__(self) -> None:
        self.books: dict[str, bool] = {}

    def add_book(self, title: str) -> None:
        """Add a book to the library if it doesn't exist"""
        if title in self.books:
            print(f"'{title}' already exists in the library.")
        else:
            self.books[title] = True
            print(f"Added: {title}")

    def display_books(self) -> None:
        """Show available books"""
        available = [title for title, status in self.books.items() if status]
        if available:
            print("Available Books:")
            for book in available:
                print(f"- {book}")
        else:
            print("No books available.")


class Member:
    def __init__(self) -> None:
        self.borrowed_books: list[str] = []

    def borrow_book(self, library: 'Library', title: str) -> None:
        """Borrow a book from the library"""
        if title not in library.books:
            print(f"Book '{title}' not found in library.")
            return
            
        if library.books[title]:
            library.books[title] = False
            self.borrowed_books.append(title)
            print(f"Borrowed: {title}")
        else:
            print(f"'{title}' is not available for borrowing.")

    def return_book(self, library: 'Library', title: str) -> None:
        """Return a borrowed book to the library"""
        if title not in self.borrowed_books:
            print(f"You haven't borrowed '{title}'.")
            return
            
        library.books[title] = True
        self.borrowed_books.remove(title)
        print(f"Returned: {title}")


def main() -> None:
    library = Library()
    member = Member()
    
    actions: dict[str, str] = {
        '1': "Add Book",
        '2': "Borrow Book",
        '3': "Return Book",
        '4': "Display Books",
        '5': "Exit"
    }

    while True:
        print("\nChoose an action:")
        for key, value in actions.items():
            print(f"{key}. {value}")
            
        choice: str = input("Action: ").strip()
        
        if choice == '1':
            title: str = input("Enter book title: ").strip('"')
            library.add_book(title)
        elif choice == '2':
            title: str = input("Enter book title: ").strip('"')
            member.borrow_book(library, title)
        elif choice == '3':
            title: str = input("Enter book title: ").strip('"')
            member.return_book(library, title)
        elif choice == '4':
            library.display_books()
        elif choice == '5':
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please enter 1-5.")


if __name__ == "__main__":
    main()
