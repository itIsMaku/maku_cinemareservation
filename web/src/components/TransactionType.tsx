import React, { useState } from "react";
import "./TransactionType.css";
import Header from "./Header";
import NextButton from "./NextButton";

type TransactionTypeProps = {
    setTransactionType: (type: string) => void;
    movieName: string;
};

const TransactionType: React.FC<TransactionTypeProps> = ({
    setTransactionType,
    movieName,
}) => {
    return (
        <>
            <Header
                title="Typ transakce"
                description="Vyber typ transakce, který chceš provést."
                movieName={movieName}
            ></Header>
            <hr></hr>
            <div className="transactions-properties">
                <div className="transaction-property">
                    <input type="checkbox" checked />
                    <div className="info">
                        <p className="title">Nákup vstupenek</p>
                        <p className="description">
                            Kupte si vstupenky nyní a vyhněte se čekání ve
                            frontě u pokladny.
                        </p>
                    </div>
                </div>
                <div className="transaction-property disabled">
                    <input type="checkbox" disabled />
                    <div className="info">
                        <p className="title">Rezervace</p>
                        <p className="description">
                            Rezervujte si svá místa nyní a následně zakupte
                            vstupenky na pokladně nejpozději 30 minut před
                            představením. Některá místa je možné pouze zakoupit.
                        </p>
                    </div>
                </div>
            </div>
            <NextButton
                text="Další"
                color="orange"
                action={() => setTransactionType("buy")}
            />
        </>
    );
};

export default TransactionType;
