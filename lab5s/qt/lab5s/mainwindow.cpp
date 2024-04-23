#include "mainwindow.h"
#include "ui_mainwindow.h"

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
    std::string str1x = ui->plainTextEdit_2->toPlainText().toStdString();
    std::string str2x = ui->plainTextEdit->toPlainText().toStdString();
    str1x.push_back(0);
    str2x.push_back(0);
    char* str1 = (char*)str1x.data();
    char* str2 = (char*)str2x.data();
    char buf[255];
    fif(str1, str2, buf);
}
void MainWindow::print(char* tx, int out){
    std::string txs;
    txs.assign(tx, out);
    txs = "Результат:\n" + txs;
    ui->label_3->setText(QString::fromStdString(txs));
};

//_ZN10MainWindow3fifEPcS0_S0
//_ZN10MainWindow5printEPc
