//
//  UserNotificationManager.swift
//  Brandent
//
//  Created by Sara Babaei on 4/26/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationManager {
    
    static let sharedInstance = UserNotificationManager()
    
    //MARK: Permission
    func getPermissionForSendingNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in}
    }
    
    //MARK: Schedule Notification
    private func setNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        return content
    }
    
    private func scheduleNotification(identifier: String, content: UNMutableNotificationContent, schedule_for date: DateComponents) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func scheduleNotificationForAppointment(appointment: Appointment) {
        guard appointment.visit_time > Date() else {
            return
        }
        let content = setNotificationContent(title: appointment.disease, body: "\(appointment.patient.name) در \(appointment.clinic.title)")
        content.sound = UNNotificationSound.default
        scheduleNotification(identifier: appointment.id.uuidString, content: content, schedule_for: appointment.visit_time.getComponents())
    }
    
    func scheduleNotificationForTask(task: Task) {
        let content = setNotificationContent(title: task.clinic?.title ?? "کار", body: task.title)
        scheduleNotification(identifier: task.id.uuidString, content: content, schedule_for: task.date.getComponents())
    }
    
    //MARK: Remove Notification
    private func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    func removeNotoficationForAppointment(appointment: Appointment) {
        guard appointment.visit_time > Date() else {
            return
        }
        removeNotification(identifier: appointment.id.uuidString)
    }
    
    func removeNotificationForTask(task: Task) {
        removeNotification(identifier: task.id.uuidString)
    }
    
    //MARK: Update Notification
    func updateNotificationForAppointment(appointment: Appointment) {
        removeNotoficationForAppointment(appointment: appointment)
        scheduleNotificationForAppointment(appointment: appointment)
    }
    
    func updateNotificationForTask(task: Task) {
        removeNotificationForTask(task: task)
        scheduleNotificationForTask(task: task)
    }
}
