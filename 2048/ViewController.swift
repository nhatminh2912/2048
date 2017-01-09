//
//  ViewController.swift
//  2048
//
//  Created by Nhật Minh on 12/14/16.
//  Copyright © 2016 Nhật Minh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    
    var b = Array(repeating: Array(repeating: 0, count : 4), count: 4)
    
    var lose = false
    
    var randomAble: Bool = true
    
    var count: Int = 0
    
    var n: Int = 4 // so hang va cot
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions: [ UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions
        {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
    }
    
    func randomNum(_ type: Int)
    {
        checkLose()
        
        if lose == false
        {
            
            switch type {
            case 0: left()
            case 1: right()
            case 2: up()
            case 3: down()
            default:
                break
            }
            
            checkRandom()
            
            if randomAble == true
            {
                
                var rnlabelX = arc4random_uniform(4)
                
                var rnlabelY = arc4random_uniform(4)
                
                let rdNum = arc4random_uniform(2) == 0 ? 2 : 4
                
                while (b[Int(rnlabelX)][Int(rnlabelY)] != 0)
                {
                    rnlabelX = arc4random_uniform(4)
                    rnlabelY = arc4random_uniform(4)
                }
                
                b[Int(rnlabelX)][Int(rnlabelY)] = rdNum
                
                let numlabel = 100 + (Int(rnlabelX) * 4) + Int(rnlabelY)
                
                ConvertNumLabel(numlabel, value: String(rdNum))
                transfer()
                
                count += 1
            }
        }
            
        else
        {
            alertBox("Game Over", "You Lose", "Click")
        }
    }
    
    func changeBackColor(_ numlabel: Int, color: UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                randomNum(0)
            case UISwipeGestureRecognizerDirection.right:
                randomNum(1)
            case UISwipeGestureRecognizerDirection.up:
                randomNum(2)
            case UISwipeGestureRecognizerDirection.down:
                randomNum(3)
            default:
                break
            }
        }
    }
    
    
    func transfer()
    {
        for i in 0..<n
        {
            for j in 0..<n
            {
                let numlabel = 100 + (i * n) + j
                ConvertNumLabel(numlabel, value: String(b[i][j]))
                switch (b[i][j]) {
                case 2,4: changeBackColor(numlabel, color: UIColor.cyan)
                case 8,16: changeBackColor(numlabel, color: UIColor.green)
                case 16,32: changeBackColor(numlabel, color: UIColor.orange)
                case 64: changeBackColor(numlabel, color: UIColor.red)
                case 128,256,512: changeBackColor(numlabel, color: UIColor.yellow)
                case 1024,2048: changeBackColor(numlabel, color: UIColor.purple)
                default:
                    changeBackColor(numlabel, color: UIColor.brown)
                }
            }
        }
    }
    
    
    
    func ConvertNumLabel(_ numlabel: Int, value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    
    
    func up()
    {
        
        for col in 0..<n
        {
            var check = false
            for row in 1..<n
            {
                var tx = row
                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in ((-1 + 1)...row - 1).reversed()
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                        // xét nếu ô ở trên mà có giá trị khác với ô dưới thì không di chuyển lên
                    {
                        break
                    }
                    else // còn không thì vị trí hiện tại sẽ là ô ở trên
                    {
                        tx = rowc
                    }
                }
                if (tx == row) // nếu vị trí hiện tại thay đổi thì tiếp tục vòng lặp
                {
                    continue
                }
                if (b[row][col] == b[tx][col]) // nếu vị trí hiện tại đã thành ô trên thì + vào với nhau
                {
                    check = true
                    b[tx][col] *= 2
                    GetScore(b[tx][col])
                    count -= 1
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    
    func down()
    {
        for col in 0..<n
        {
            var check = false
            for row in 0..<n
            {
                var tx = row
                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in (row + 1)..<n
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    b[tx][col] *= 2
                    GetScore(b[tx][col])
                    count -= 1
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    func left()
    {
        for row in 0..<n
        {
            var check = false
            for col in 1..<n
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in ((-1 + 1)...col - 1).reversed()
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    b[row][ty] *= 2
                    GetScore(b[row][ty])
                    count -= 1
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    
    func right()
    {
        for row in 0..<n
        {
            var check = false
            for col in ((-1 + 1)...(n - 1)).reversed()
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in (col + 1)..<n
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    b[row][ty] *= 2
                    GetScore(b[row][ty])
                    count -= 1
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    
    func GetScore(_ value: Int)
    {
        score.text = String(Int(score.text!)! + value)
    }
    
    
    func checkRandom()
    {
        if count < (n * n)
        {
            randomAble = true
        }
        else
        {
            randomAble = false
        }
    }
    
    
    
    
    func checkLose()
    {
        if count == (n * n)
        {
            lose = true
            for row in 0..<n
            {
                for col in 0..<n
                {
                    
                    if (!outOfRange(row: row + 1, col: col))
                    {
                        if (b[row][col] == b[row + 1][col])
                        {
                            lose = false
                        }
                    }
                    if (!outOfRange(row: row - 1, col: col))
                    {
                        if (b[row][col] == b[row - 1][col])
                        {
                            lose = false
                        }
                    }
                    if (!outOfRange(row: row, col: col + 1))
                    {
                        if (b[row][col] == b[row][col + 1])
                        {
                            lose = false
                        }
                    }
                    if (!outOfRange(row: row, col: col - 1))
                    {
                        if (b[row][col] == b[row][col - 1])
                        {
                            lose = false
                        }
                    }
                    
                }
            }
        }
    }
    

    func outOfRange(row: Int, col: Int) -> Bool
    {
        if (row < 0 || row > n - 1 || col < 0 || col > n - 1)
        {
            return true
        }
        return false
    }
    func alertBox(_ title: String, _ message: String, _ actionTitle: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

