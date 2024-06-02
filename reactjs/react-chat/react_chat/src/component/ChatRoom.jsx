import React, { useState } from "react";
import SockJS from "sockjs-client/dist/sockjs";
import { over } from "stompjs";
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/ReactToastify.css'

var stompClient = null;
export default function ChatRoom() {

    const [chat, setChat] = useState([]);
    const [user, setUser] = useState({
        username: "",
        message: "",
        isConnected: false
    });

    const handleConnect = (event) => {
        if (!user.username) {
            toast.error('Please enter a username'); // Show error toast
            event.preventDefault(); // Prevent default form submission behavior
            return;
        }
        let socket = new SockJS('http://localhost:8081/ws');
        stompClient = over(socket);
        stompClient.connect({}, onConnected, onError);
        event.preventDefault();
    }

    const onConnected = () => {
        toast.success("Successfully connected");
        setUser(prevUser => ({ ...prevUser, isConnected: true }));
        console.log("Connected")
        stompClient.subscribe('/chatroom/message', onMessageReceived)
    }

    const onError = (err) => {
        toast.error('Connection failed.');
        console.log(err);
    }

    const handleMessageChange = (e) => {
        setUser(prevUser => ({ ...prevUser, message: e.target.value }));
    };

    const onSendMessage = (payload) => {
        if (stompClient) {
            if (user.message.trim() !== '') {
                var chatMessage = {
                    sender: user.username,
                    message: user.message
                };

                console.log(chatMessage);
                stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
                setUser({ ...user, "message :": "" });

            } else {
                toast.error("Message can not be empty");
            }
        }
        console.log(chat.length);
    }

    const onMessageReceived = (payload) => {
        var payloadData = JSON.parse(payload.body);
        chat.push(payloadData);
        console.log(chat[0])
        setChat([...chat]);
    }

    return (
        <div className="bg-gray-100">
            {user.isConnected ? // check if user is connected
                <div className="h-screen overflow-hidden flex flex-col items-center ">
                    <h1 className="text-4xl font-bold text-center mt-4 text-teal-500">Communication space</h1>
                    <div className="w-3/4 m-20 bg-slate-50 rounded-xl shadow-xl h-full border-4 border-teal-500">
                        {/* inside component */}
                        <div className="p-5 h-full">
                            <div className="chat-container">
                                <ul className="space-y-2">
                                    {chat.map((chat, index) => (
                                        <li
                                            className={`message ${chat.sender === user.username && "self"}`}
                                            key={index}
                                        >
                                            <div className="flex flex-col items-start">
                                                <div
                                                    className={`message-content p-3 flex flex-col max-w-[320px] leading-1.5 border-gray-200 rounded-l-xl rounded-r-xl ${chat.sender === user.username ? "bg-teal-100 dark:bg-teal-700 text-left" : "bg-gray-100 dark:bg-gray-700 text-right"}`}
                                                >
                                                    <div className="flex items-center space-x-2 rtl:space-x-reverse">
                                                        <span className="text-sm font-semibold text-gray-900 dark:text-teal-300">
                                                            {chat.sender}
                                                        </span>
                                                    </div>
                                                    <p className="text-sm font-normal py-2.5 text-gray-900 dark:text-white">
                                                        {chat.message}
                                                    </p>
                                                    <span className="text-sm font-normal text-gray-500 dark:text-gray-400">
                                                        Delivered
                                                    </span>
                                                </div>
                                            </div>
                                        </li>
                                    ))}
                                </ul>



                            </div>
                            {/* // input section */}
                            <div className="sticky top-[100vh] flex justify-evenly">
                                <input
                                    className="p-1.5 bg-teal-200 rounded-lg w-4/5 border-2 border-teal-500"
                                    type="text"
                                    placeholder="Your Message"
                                    value={user.message}
                                    onChange={handleMessageChange}
                                />
                                <button
                                    className="bg-transparent hover:bg-teal-500 text-teal-500 font-semibold hover:text-white py-2 px-4 border-2 border-teal-500 hover:border-transparent rounded w-2/12"
                                    onClick={onSendMessage}
                                >
                                    Send
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                :
                <div className="h-screen flex items-center justify-center flex-col gap-20">
                    <h1 className="text-4xl font-bold text-center mt-4 text-teal-500">WebSocket Spring + React</h1>
                    <form className="w-full max-w-sm" onSubmit={handleConnect}>
                        <div className="flex items-center border-b border-teal-500 py-2">
                            <input
                                className="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                                type="text"
                                placeholder="Username"
                                value={user.username}
                                onChange={(e) => setUser({ ...user, username: e.target.value })}
                            />
                            <button
                                className="flex-shrink-0 bg-teal-500 hover:bg-teal-700 border-teal-500 hover:border-teal-700 text-sm border-4 text-white py-1 px-2 rounded"
                                type="submit"
                            >
                                Connect
                            </button>
                        </div>
                    </form>
                </div>}
            <ToastContainer />
        </div>
    )
}