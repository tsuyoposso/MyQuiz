//
//  QuestionViewController.swift
//  MyQuiz
//
//  Created by 長坂豪士 on 2019/09/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit
import AudioToolbox

class QuestionViewController: UIViewController {
    
    var questionData: QuestionData!
    
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    @IBOutlet weak var correctImageView: UIImageView!
    @IBOutlet weak var incorrectImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期データ設定処理。前画面で設定済みのquestionDataから値を取り出す
        questionNoLabel.text = "Q. \(questionData.questionNo)"
        questionTextView.text = questionData.question
        answer1Button.setTitle(questionData.answer1, for: UIControl.State.normal)
        answer2Button.setTitle(questionData.answer2, for: UIControl.State.normal)
        answer3Button.setTitle(questionData.answer3, for: UIControl.State.normal)
        answer4Button.setTitle(questionData.answer4, for: UIControl.State.normal)
        
    }
    
    // 選択肢のタップ処理
    @IBAction func tapAnswer1Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 1
        goNextQuestionWithAnimation()
    }
    
    @IBAction func tapAnswer2Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 2
        goNextQuestionWithAnimation()
    }
    
    @IBAction func tapAnswer3Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 3
        goNextQuestionWithAnimation()
    }
    
    @IBAction func tapAnswer4Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 4
        goNextQuestionWithAnimation()
    }
    
    // 次の問題にアニメーション付きで進む
    func goNextQuestionWithAnimation() {
        if questionData.isCorrect() {
            goNextQuestionWithCorrectAnimation()
        } else {
            goNextQuestionWithIncorrectAnimation()
        }
    }
    
    // 正解時のアニメーション遷移
    func goNextQuestionWithCorrectAnimation() {
        AudioServicesPlayAlertSound(1025)
        // アニメーション
        UIView.animate(withDuration: 2.0, animations: {
            // アルファ値を1.0に変化させる(初期値はStoryBoardで0.0に設定済み)
            self.correctImageView.alpha = 1.0
        }) { (Bool) in
            self.goNextQuestion()  // アニメーション完了時に次の問題に進む
        }
    }
    
    // 不正解時のアニメーション遷移
    func goNextQuestionWithIncorrectAnimation() {
        AudioServicesPlayAlertSound(1006)
        UIView.animate(withDuration: 2.0, animations: {
            self.incorrectImageView.alpha = 1.0
        }) { (Bool) in
            self.goNextQuestion()
        }
    }
    
    // 次の問題へ遷移する
    func goNextQuestion() {
        // 問題文の取り出し
        guard let nextQuestion = QuestionDataManager.sharedInstance.nextQuestion() else {
            // 問題文がなければ結果画面へ遷移する
            // StoryBoardのIdentifierに設定した値(result)を指定して
            // Viewontrollerを生成する
            if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "result") as? ResultViewController {
                // StoryBoardのsegueを利用しない明示的な画面遷移処理
                present(resultViewController, animated: true, completion: nil)
            }
            return
        }
        
        // 問題文がある場合は次の問題へ遷移する
        // StoryBoardのIdentifierに設定した値(question)を設定して
        // ViewControllerを生成する
        if let nextQuestionViewController = storyboard?.instantiateViewController(withIdentifier: "question") as? QuestionViewController {
            nextQuestionViewController.questionData = nextQuestionViewController
            present(nextQuestionViewController, animated: true, completion: nil)
        }
    }
}
