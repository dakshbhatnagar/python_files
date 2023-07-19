// Exercise 1: Guess the number
// Prize Amount: Rs 500 Amazon voucher
let number = 9
let chances = 0
let guess = prompt("Guess the number")

while (guess){
    if (chances < 100){
        Guess = Number.parseInt(guess)
        if(Guess === number){
            console.log(`You guessed the number correctly in ${chances}`)
            break;
                            }
        else {
            console.log(`Please try again`)
            chances++;
            guess = prompt("Guess the number")
        }
    }
    else {
        console.log('You ran out of your chances.')
        break;
        }
    }