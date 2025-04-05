extends Node

signal shake_triggered  # 定义一个全局信号

func start_shake():
    shake_triggered.emit()  # 触发信号，通知所有监听者
