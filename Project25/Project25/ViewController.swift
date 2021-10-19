//
//  ViewController.swift
//  Project25
//
//  Created by Domagoj Sutalo on 25.08.2021..
//
import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var images = [UIImage]()
    var peerID: MCPeerID?
    var mcSession: MCSession?
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtons()
        setSession()
        title = "Selfie Share"
    }
    
    func setSession(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: "Project25", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
            invitationHandler(true, self?.mcSession)
        }))
        ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
            invitationHandler(false, nil)
        }))
        present(ac, animated: true)
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.widthAnchor.constraint(equalToConstant: 145).isActive = true
        cell.heightAnchor.constraint(equalToConstant: 145).isActive = true
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        cell.viewWithTag(1000)?.sizeToFit()
        return cell
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else {return}
        if mcSession.connectedPeers.count > 0{
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch{
                    callAC(title: "Send error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func startHosting(action: UIAlertAction){
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID!, discoveryInfo: nil,serviceType: "ds-project25")
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()
    }

    @objc func joinSession(action: UIAlertAction){
        guard let mcSession = mcSession else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "ds-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data){
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else{
                let message = String(decoding: data, as: UTF8.self)
                self?.callAC(title: "You got message!", message: message)
            }
        }
    }
    
    func setBarButtons(){
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let peers = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPeers))
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let message = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendMessage))
        
        navigationItem.leftBarButtonItems = [add,peers]
        navigationItem.rightBarButtonItems = [camera,message]
    }
    
    @objc func sendMessage(){
        let ac = UIAlertController(title: "Send new message", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter message"
        }
        ac.addAction(UIAlertAction(title: "Send", style: .default,handler: { [weak self, weak ac] _ in
            guard let message = ac?.textFields?[0].text else {return}
            let data = Data(message.utf8)
            guard let mcSession = self?.mcSession else {return}
            if mcSession.connectedPeers.count > 0{
                do{
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch{
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac,animated: true)
                }
            }
        }))
        present(ac, animated: true)
    }
    
    @objc func showPeers(){
        var connectedPeers = ""
        guard let mcSession = mcSession else {return}
        if mcSession.connectedPeers.count > 0{
            for peer in mcSession.connectedPeers{
                connectedPeers += "\(peer.displayName)\n"
            }
        } else{
            connectedPeers = "No peer connected"
        }
        callAC(title: "Connected peers list",message: nil)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")

        case .connecting:
            print("Connecting: \(peerID.displayName)")

        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            callAC(title: "\(peerID) disconnected",message: nil)
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func callAC(title: String,message: String?){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

