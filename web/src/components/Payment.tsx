import React, { useEffect, useState } from "react";
import "./Payment.css";
import Header from "./Header";
import NextButton from "./NextButton";
import { TheatreSeat } from "./SelectSeat";
import { fetchNui } from "../utils/fetchNui";

type PaymentProps = {
    seats: Array<TheatreSeat>;
    movieName: string;
    theatre: string;
};

const Payment: React.FC<PaymentProps> = ({ seats, movieName, theatre }) => {
    return (
        <>
            <Header
                title="Zaplacení objednávky"
                description="Prosím, zkontrolujte si objednávku a potvrďte ji."
                movieName={movieName}
            ></Header>
            <hr></hr>
            <div className="summary">
                <div className="seats">
                    {seats.map((seat) => {
                        return (
                            <div className="seat" key={seat.id}>
                                <div className="info">
                                    <p className="title">
                                        Vstupenka {seats.indexOf(seat) + 1}
                                    </p>
                                    <p className="description">
                                        Musí být uplatněno minimálně 10 minut
                                        před začátkem představení.
                                    </p>
                                </div>
                                <div className="row">
                                    <p>Řada</p>
                                    <p>{seat.row}</p>
                                </div>
                                <div className="position">
                                    <p>Místo</p>
                                    <p>{seat.id}</p>
                                </div>
                                <div className="price">
                                    <p>{seat.price}$</p>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
            <NextButton
                text="Zaplatit"
                color="green"
                action={() => {
                    fetchNui("pay", { seats: seats, theatre: theatre });
                }}
            />
        </>
    );
};

export default Payment;
