#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDebug>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    std::string txs = ui->plainTextEdit->toPlainText().toStdString();
    txs.push_back(96);
    char* tx = (char*)txs.data();
    parseasm(tx);
    printstr(tx, 2);
}
void MainWindow::printstr(char* tx, int out){
    std::string txs;
    txs.assign(tx, out);
    ui->plainTextEdit->setPlainText(QString::fromStdString(txs));
};
