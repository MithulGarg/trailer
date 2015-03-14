//
//  PRDetailController.swift
//  Trailer
//
//  Created by Paul Tsochantaris on 14/03/2015.
//
//

import WatchKit
import Foundation

let shortDateFormatter = { () -> NSDateFormatter in
    let d = NSDateFormatter()
    d.dateStyle = NSDateFormatterStyle.ShortStyle
    d.timeStyle = NSDateFormatterStyle.ShortStyle
    return d
    }()

class PRDetailController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!

    var pullRequest: PullRequest!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let contextData = context as NSDictionary
        pullRequest = contextData[PULL_REQUEST_KEY] as PullRequest

        self.setTitle(pullRequest.title)

        var displayedStatuses = pullRequest.displayedStatuses()

        var rowTypes = [String]()

        for s in displayedStatuses {
            rowTypes.append("StatusRow")
        }

        rowTypes.append("LabelRow")

        for c in pullRequest.comments.allObjects as [PRComment] {
            rowTypes.append("CommentRow")
        }
        table.setRowTypes(rowTypes)

        var index = 0

        for s in displayedStatuses {
            let controller = table.rowControllerAtIndex(index++) as StatusRow
            controller.labelL.setText(s.displayText())
            controller.labelL.setTextColor(s.colorForDarkDisplay())
        }

        (table.rowControllerAtIndex(index++) as LabelRow).labelL.setText(pullRequest.body)

        for c in pullRequest.comments.allObjects as [PRComment] {
            let controller = table.rowControllerAtIndex(index++) as CommentRow
            controller.usernameL.setText((c.userName ?? "(unknown)") + " " + shortDateFormatter.stringFromDate(c.createdAt ?? NSDate()))
            controller.commentL.setText(c.body)
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func refreshSelected() {
        presentControllerWithName("Command Controller", context: "refresh")
    }
}
