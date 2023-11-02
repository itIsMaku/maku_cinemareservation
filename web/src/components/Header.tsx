import React, { useState } from "react";
import "./Header.css";

type HeaderProps = {
    title: string;
    description: string;
    movieName: string;
};

const Header: React.FC<HeaderProps> = ({ title, description, movieName }) => {
    return (
        <div className="header">
            <p className="movie-name">{movieName}</p>
            <p className="title">{title}</p>
            <p className="description">{description}</p>
        </div>
    );
};

export default Header;
