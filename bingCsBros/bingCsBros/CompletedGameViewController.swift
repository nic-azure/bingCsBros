//
//  CompletedGameViewController.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 4/29/21.
//

import UIKit
import CoreData

class CompletedGameViewController: UIViewController{

    @IBOutlet var finalScoreLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var madeToLeaderboard: UILabel!
    


    var scoreDB: Int?
    var levelDB: Int?
    var scoresString: String?
    var namesString: String?
    var scoreboard: [NSManagedObject]?
    var leaderboard: [NSManagedObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: set finalScoreLabel to contain actual score
        scoreboard = ScoreboardDatabase.fetchScoreboard()
        leaderboard = LeaderboardDatabase.fetchLeaderboard()
        print("leaderboard")
        print(leaderboard)
        if(scoreboard!.count == 0 ){
            print("SAVING SCOREBOARD 1ST TIME")
            scoreboard = ScoreboardDatabase.saveFirstScoreboard()
        }
        else{
            scoreDB = scoreboard?[0].value(forKey: "score") as! Int
        }
        
        
        
        if(leaderboard!.count == 0 ){
            print("SAVING LEADERBOARD 1ST TIME")
            leaderboard = LeaderboardDatabase.saveFirstLeaderboard()
<<<<<<< Updated upstream
            scoresString = leaderboard?[0].value(forKey: "top5Scores") as! String
            namesString = leaderboard?[0].value(forKey: "topNames") as! String
=======
>>>>>>> Stashed changes
        }
        
        else {
            scoresString = leaderboard?[0].value(forKey: "top5Scores") as! String
            namesString = leaderboard?[0].value(forKey: "topNames") as! String
        }
        
        finalScoreLabel.text = "Final Score: " + String(scoreDB!)
        let onLeaderboard = checkIfNewScoreOnLeaderboard()
        if(onLeaderboard) {
            submitButton.isHidden = false
            nameTextField.isHidden = false
            madeToLeaderboard.isHidden = false
            print("on leaderboard")
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    

    func checkIfNewScoreOnLeaderboard() -> Bool{
        print("checking if score on leaderboard")
        scoresString = leaderboard?[0].value(forKey: "top5Scores") as! String
        print("past scores string")
        var scores = scoresString!.components(separatedBy: ",")
        let scoresInt =  scores.map { Int($0)!}
        var indexOfNewScore = -1
        print("ab to go through loop")
        for i in stride(from: scoresInt.count - 1, to: -1, by: -1) {
            print("in loop " + String(i))
            if(scoreDB! > scoresInt[i] ){
                indexOfNewScore = i
            }
        }
        
        print("got through loop")

        if(indexOfNewScore != -1 ){
            print("returning")
            return true
        }
        print("returning")
        return false
        
       
        
    }
    
    func addNewScoreOnLeaderboard(){
        
//        let scoresString = leaderboard?[0].value(forKey: "top5Scores") as! String
//        let namesString = leaderboard?[0].value(forKey: "topNames") as! String
        var scores = scoresString!.components(separatedBy: ",")
        var names = namesString!.components(separatedBy: ",")
        let scoresInt =  scores.map { Int($0)!}
        var indexOfNewScore = -1
        for i in stride(from: scoresInt.count - 1, to: -1, by: -1) {
            if(scoreDB! > scoresInt[i] ){
                indexOfNewScore = i
            }
        }
        print("going to add")
        
        if(indexOfNewScore != -1 ){
            print("new high score!")
            scores.insert(String(scoreDB!), at: indexOfNewScore )
            scores.removeLast()
            names.insert(nameTextField.text!, at: indexOfNewScore )
            names.removeLast()
            let scoreStringUpdated = (scores.map{String($0)}).joined(separator: ",")
            let nameStringUpdated  = (names.map{String($0)}).joined(separator: ",")
            
            //insert new value at i and remove last value
            LeaderboardDatabase.updateTop5(newList: scoreStringUpdated, newNames: nameStringUpdated, leaderboardToUpdate: leaderboard?[0] as! Leaderboard)
        }
                
       
        
    }
    
    @IBAction func submitName(sender: UIButton){
            //TODO: set score back to 0
        print("submitting name")
        addNewScoreOnLeaderboard()
        nameTextField.text = ""
        }
    

    @IBAction func clickPlayAgainButton(sender: UIButton){
            //TODO: set score back to 0
        print("play again")
        ScoreboardDatabase.updateLevel(newLevel: 1, scoreboardToUpdate: scoreboard![0] as! Scoreboard)
        ScoreboardDatabase.updateScore(newScore: 0, scoreboardToUpdate: scoreboard![0] as! Scoreboard)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
     /!/ MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
