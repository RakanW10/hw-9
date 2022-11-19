import 'classes/Book.dart';
import 'classes/user.dart';
import 'package:chalkdart/chalk.dart';
import 'dart:io';


enum oprations { exit, add, delete, edit, viewInfo }

Book b1 = Book(
    id: 1,
    titel: "Start with why",
    author: "Simon Silk",
    price: 80.0,
    quantity: 13);
Book b2 = Book(
    id: 2,
    titel: "But how do it know",
    author: "J. Clark Scott",
    price: 59.9,
    quantity: 22);
Book b3 = Book(
    id: 3,
    titel: "Clean Code",
    author: "Robert Cecil Martin",
    price: 80.0,
    quantity: 5);
Book b4 = Book(
    id: 4,
    titel: "Zero to One",
    author: "Peter Thiel",
    price: 80.0,
    quantity: 12);
Book b5 = Book(
    id: 5,
    titel: "You don't know JS",
    author: "Kyle Simpson",
    price: 80.0,
    quantity: 9);

List<Book> books = [b1, b2, b3, b4, b5];
void main() {
  bool run = true;
  int op = 1;

  do {
    menu();
    stdout.write("Enter your choice: ");
    // check if the uesr does'n enter anything
    int op = checkInt(stdin.readLineSync()!);

    if (op == oprations.exit.index) {
      run = false;
    } else if (op == oprations.add.index) {
      addBook();
    } else if (op == oprations.delete.index) {
      removeBook();
    } else if (op == oprations.edit.index) {
      print("edit");
      print(books);
    } else if (op == oprations.viewInfo.index) {
      print("viewInfo");
    } else
      print("Wrong number");
    print("\n\n");
  } while (run);
  print("Thank you. ;)");
}

// To print the menu.
void menu() {
  print("=" * 82);
  print("==\t\t\t\t\t\t\t\t\t\t==");
  print(chalk.yellow.onBlue.bold("==\t\t\t\tLibrary\t\t\t\t\t        =="));
  print("==\t\t\t\t\t\t\t\t\t\t==");
  print("=" * 82);
  print(chalk.underline.blink.blue("== 1) To add a book, choose 1\t\t\t\t\t\t\t=="));
  print(chalk.underline.blink.blue("== 2) To remove a book, choose 2\t\t\t\t\t\t=="));
  print(chalk.underline.blink.blue("== 3) To edit a book, choose 3\t\t\t\t\t\t\t=="));
  print(chalk.underline.blink.blue("== 4) To view information, choose 4\t\t\t\t\t\t=="));
  print(chalk.underline.blink.blue("== 0) To exit, choose 0\t\t\t\t\t\t\t\t=="));
  print("=" * 82);
}

/* Serach about BookId in the books list,
   if found: return it's index
   else: return -1. to indect there is no book with this BookId.
*/
int serachByID(int bookId) {
  for (int bookIndex = 0; bookIndex < books.length; bookIndex++) {
    if (books[bookIndex].id == bookId) return bookIndex;
  }
  return -1;
}

/* Serach about BookTitle in the books list,
   if found: return it's index
   else: return -1. to indect there is no book with this BookTitle.
   Note: we assume there is no two books with the same title 
*/
int serachByTitle(String bookTitle) {
  for (int bookIndex = 0; bookIndex < books.length; bookIndex++) {
    if (books[bookIndex].titel == bookTitle) return bookIndex;
  }
  return -1;
}

/* Serach about BookAuthor in the books list,
   if found: return list of indexs, that this BookAuthor Authored.
   else: return -1. to indect there is no book with this BookAuthor.
*/
dynamic serachByAuthor(String bookAuthor) {
  List<int> listOfIndexs = [];
  for (int bookIndex = 0, i = 0; bookIndex < books.length; bookIndex++) {
    if (books[bookIndex].author == bookAuthor) listOfIndexs[i++];
  }
  if (listOfIndexs.isEmpty)
    return -1;
  else
    return listOfIndexs;
}

void addBook() {
  int bookId;
  do {
    // check if the book id is already exist or not
    stdout.write("Please enter the book ID: ");
    bookId = checkInt(stdin.readLineSync()!);

    if (bookId == 0) return;
    if (serachByID(bookId) != -1) {
      print(
        chalk.onRed("This book id alread exist.\nplease enter anothor or (0) to exit. "));
    } else
      break;
  } while (true);
  String bookTitle;
  do {
    // we assumed the book title is unique
    // check if the book title is already exist or not,
    stdout.write("Please enter the title of the book: ");
    bookTitle = stdin.readLineSync()!;
    if (bookTitle == "0") return;
    if (serachByTitle(bookTitle) != -1) {
      print(
        chalk.onRed  ("This book title alread exist.\nplease enter anothor or (0) to exit. "));
    } else
      break;
  } while (true);

  stdout.write("Please enter the author of the book: ");
  String author = stdin.readLineSync()!;
  stdout.write("Please enter the price of the book: ");
  double priceBook = checkdouble(stdin.readLineSync()!);
  stdout.write("Please enter quantity of the book:");
  int quantityBook = checkInt(stdin.readLineSync()!);
  books.add(Book(
      id: bookId,
      titel: bookTitle,
      author: author,
      price: priceBook,
      quantity: quantityBook));
  print("Book is added");
}

void removeBook() {
  stdout.write("Enter book ID or Title: ");
  String idOrTitle = stdin.readLineSync()!;
  int bookIndex = serachByTitle(idOrTitle);
  Book removedBook;
  if (bookIndex != -1) {
    // title is found. removing ...
    removedBook = books.removeAt(bookIndex);
    print(chalk.bgBlue("Book with title [${removedBook.getTitle}] is removed."));
  } else {
    // it is not a title. search for id or it could be an invaled input.
    try {
      bookIndex = serachByID(int.parse(idOrTitle));
      if (bookIndex != -1) {
        // id is found. removing ...
        removedBook = books.removeAt(bookIndex);
        print(chalk.bgBlue("Book with title [${removedBook.getTitle}] is removed."));
      } else {
        print(chalk.onRed("There is no book with the given Id or Title"));
      }
    } catch (e) {
      print(chalk.onRed("There is no book with the given Id or Title"));
    }
  }
}

/*---------------------Support Functions---------------------*/
/* To check if the given op can be parsed to int, 
   if yes: it well retuen the result as int value,
   else: it well ask the user to enter an integer.
*/
int checkInt(String op) {
  int returnOp = -1;
  do {
    if (op.length > 0) {
      //op is not empty
      try {
        returnOp = int.parse(op);
        break;
      } catch (e) {/* do nothing */}
    }
    stdout.write(chalk.onRed("Wrong input, please enter an integer number "));
    op = stdin.readLineSync()!;
  } while (true);
  return returnOp;
}

/* To check if the given op can be parsed to double, 
   if yes: it well retuen the result as double value,
   else: it well ask the user to enter a double.
*/
double checkdouble(String op) {
  double returnOp = -1;
  do {
    if (op.length > 0) {
      //op is not empty
      try {
        returnOp = double.parse(op);
        break;
      } catch (e) {/* do nothing */}
    }
    stdout.write(chalk.onRed("Wrong input, please choose one of the serveces: "));
    op = stdin.readLineSync()!;
  } while (true);
  return returnOp;
}